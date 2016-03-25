//
//  MessageDetailPreviewCellTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 24/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "MessageDetailPreviewCell.h"

SPEC_BEGIN(MessageDetailPreviewCellTests)

describe(@"MessageDetailPreviewCell", ^{
    
    __block MessageDetailPreviewCell* cell;
    
    beforeEach(^{
        cell = (MessageDetailPreviewCell*)[[[NSBundle mainBundle] loadNibNamed:@"MessageDetailPreviewCell" owner:self options:nil] firstObject];
    });
    
    it(@"should be load from nib properly", ^{
        [[cell shouldNot] beNil];
        [[cell should] beKindOfClass:[MessageDetailPreviewCell class]];
    });
    
    describe(@"name text view", ^{
        __block UITextView* nameTextView;
        
        beforeEach(^{
            nameTextView = cell.nameTextView;
        });
        
        it(@"should exist", ^{
            [[nameTextView shouldNot] beNil];
        });
        
        it(@"should have disable scrolling and editing", ^{
            [[theValue(nameTextView.scrollEnabled) should] beFalse];
            [[theValue(nameTextView.editable) should] beFalse];
        });
        
        it(@"should have zero insets", ^{
            [[theValue(nameTextView.textContainerInset) should] equal:theValue(UIEdgeInsetsMake(0, 0, 0, 0))];
        });
    });

    describe(@"snippet text view", ^{
        __block UITextView* snippetTextView;
        
        beforeEach(^{
            snippetTextView = cell.snippetTextView;
        });
        
        it(@"should exist", ^{
            [[snippetTextView shouldNot] beNil];
        });
        
        it(@"should have disable scrolling and editing", ^{
            [[theValue(snippetTextView.scrollEnabled) should] beFalse];
            [[theValue(snippetTextView.editable) should] beFalse];
        });
        
        it(@"should have zero insets", ^{
            [[theValue(snippetTextView.textContainerInset) should] equal:theValue(UIEdgeInsetsMake(0, 0, 0, 0))];
        });
    });

    describe(@"timestamp label", ^{
        __block UILabel* timestampLabel;
        
        beforeEach(^{
            timestampLabel = cell.timestampLabel;
        });
        
        it(@"should exist", ^{
            [[timestampLabel shouldNot] beNil];
        });
    });

    describe(@"avatar image view", ^{
        __block UIImageView* avatarImageView;
        
        beforeEach(^{
            avatarImageView = cell.avatarImageView;
        });
        
        it(@"should exist", ^{
            [[avatarImageView shouldNot] beNil];
        });
    });
    
    it(@"should load data from MessageDetailPreviewCellDataSource", ^{
        NSObject<MessageDetailPreviewCellDataSource>* dataSource = [KWMock mockForProtocol:@protocol(MessageDetailPreviewCellDataSource)];

        UIImage* image = [UIImage new];

        [dataSource stub:@selector(avatarImage) andReturn:image];
        [dataSource stub:@selector(name) andReturn:@"The Emperor"];
        [dataSource stub:@selector(subject) andReturn:@"Return of the Jedi"];
        [dataSource stub:@selector(body) andReturn:nil];
        [dataSource stub:@selector(snippet) andReturn:@"Now, young Skywalker… you will die."];
        [dataSource stub:@selector(timestampString) andReturn:@"Yesterday"];

        [cell loadData:dataSource];

        [[cell.nameTextView.text should] equal:@"The Emperor"];
        [[cell.snippetTextView.text should] equal:@"Now, young Skywalker… you will die."];
        [[cell.avatarImageView.image should] beIdenticalTo:image];
        [[cell.timestampLabel.text should] equal:@"Yesterday"];
    });

    it(@"should reset all outlets to the default state when prepareForReuse is called", ^{
        [cell prepareForReuse];
        
        [[cell.nameTextView.text should] equal:@""];
        [[cell.snippetTextView.text should] equal:@""];
        [[cell.timestampLabel.text should] equal:@""];
        [[cell.avatarImageView.image should] beNil];
    });
    
    it(@"should have previewHeight 55", ^{
        [[theValue([MessageDetailPreviewCell previewHeight]) should] equal:theValue(55)];
    });
    
    it(@"should compute desired height correctly", ^{
        NSObject<MessageDetailPreviewCellDataSource>* dataSource = [KWMock mockForProtocol:@protocol(MessageDetailPreviewCellDataSource)];
        
        NSString* body = @"Luke, you can destroy the Emperor. \n He has foreseen this. \n It is your destiny. \n Join me, and together we can rule the galaxy as father and son.";
        UIImage* image = [UIImage new];
        
        [dataSource stub:@selector(avatarImage) andReturn:image];
        [dataSource stub:@selector(name) andReturn:@"The Emperor"];
        [dataSource stub:@selector(subject) andReturn:@"Return of the Jedi"];
        [dataSource stub:@selector(body) andReturn:body];
        [dataSource stub:@selector(snippet) andReturn:@"Now, young Skywalker… you will die."];
        [dataSource stub:@selector(timestampString) andReturn:@"Yesterday"];
        
        UIFont *usedFont = cell.snippetTextView.font;
        NSDictionary *attributes = @{NSFontAttributeName : usedFont};
        
        CGFloat bodyHeight = [body boundingRectWithSize:CGSizeMake(500 - 2*16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
        CGFloat headerHeight = [MessageDetailPreviewCell previewHeight];
        CGFloat cellHeight = bodyHeight + headerHeight + 8; // 8 are borders
        
        CGFloat computedValue = [MessageDetailPreviewCell desiredHeightForWidth:500 andData:dataSource];
        
        [[theValue(cellHeight) should] equal:theValue(computedValue)];
    });

});

SPEC_END