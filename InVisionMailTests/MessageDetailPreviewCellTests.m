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
    });

    describe(@"snippet text view", ^{
        __block UITextView* snippetTextView;
        
        beforeEach(^{
            snippetTextView = cell.snippetTextView;
        });
        
        it(@"should exist", ^{
            [[snippetTextView shouldNot] beNil];
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


});

SPEC_END