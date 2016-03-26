//
//  MessageListCellTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 16/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "MessageListCell.h"

// Expose private functions needed for testing
@interface MessageListCell (Private)
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UILabel* subjectLabel;
@property (nonatomic, weak) UILabel* snippetLabel;
@property (nonatomic, weak) UILabel* timestampLabel;
@property (nonatomic, weak) UIView* unreadMark;
@property (nonatomic, weak) UIImageView* attachmentIcon;
@end


SPEC_BEGIN(MessageListCellTests)

describe(@"MessageListCell", ^{
    
    __block MessageListCell* cell;
    
    beforeEach(^{
        cell = (MessageListCell*)[[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:self options:nil] firstObject];
    });
    
    it(@"should be load from nib properly", ^{
        [[cell shouldNot] beNil];
        [[cell should] beKindOfClass:[MessageListCell class]];
    });
    
    describe(@"name label", ^{
        __block UILabel* label;
        
        beforeEach(^{
            label = cell.nameLabel;
        });
        
        it(@"should exist", ^{
            [[label shouldNot] beNil];
        });
    });
    
    describe(@"subject label", ^{
        __block UILabel* label;
        
        beforeEach(^{
            label = cell.subjectLabel;
        });
        
        it(@"should exist", ^{
            [[label shouldNot] beNil];
        });
    });
    
    describe(@"snippet label", ^{
        __block UILabel* label;
        
        beforeEach(^{
            label = cell.snippetLabel;
        });
        
        it(@"should exist", ^{
            [[label shouldNot] beNil];
        });
    });

    describe(@"timestamp label", ^{
        __block UILabel* label;
        
        beforeEach(^{
            label = cell.timestampLabel;
        });
        
        it(@"should exist", ^{
            [[label shouldNot] beNil];
        });
    });

    
    describe(@"unread mark", ^{
        __block UIView* mark;
        
        beforeEach(^{
            mark = cell.unreadMark;
        });
        
        it(@"should exist", ^{
            [[mark shouldNot] beNil];
        });
        
        it(@"should be visible when message is unread", ^{
            NSObject<MessageListCellDataSource>* dataSource = [KWMock mockForProtocol:@protocol(MessageListCellDataSource)];
            [dataSource stub:@selector(unread) andReturn:theValue(YES)];
            [dataSource stub:@selector(name) andReturn:@"The Emperor"];
            [dataSource stub:@selector(subject) andReturn:@"Return of the Jedi"];
            [dataSource stub:@selector(snippet) andReturn:@"Now, young Skywalker… you will die."];
            [dataSource stub:@selector(timestampString) andReturn:@"1977000"];
            
            [cell loadData:dataSource];
            
            [[theValue(mark.hidden) should] beFalse];
        });
    });

    describe(@"attachment icon", ^{
        __block UIImageView* icon;
        
        beforeEach(^{
            icon = cell.attachmentIcon;
        });
        
        it(@"should exist", ^{
            [[icon shouldNot] beNil];
        });

        it(@"should shave 'attachment' icon image", ^{
            UIImage* image = icon.image;
            [[image should] equal:[UIImage imageNamed:@"attachment"]];
        });
    });
    
    it(@"should reset all outlets to the default state when prepareForReuse is called", ^{
        [cell prepareForReuse];
        
        [[cell.nameLabel.text should] beNil];
        [[cell.subjectLabel.text should] beNil];
        [[cell.timestampLabel.text should] beNil];
        [[theValue(cell.unreadMark.hidden) should] beYes];
        [[theValue(cell.attachmentIcon.hidden) should] beYes];
    });
});

SPEC_END