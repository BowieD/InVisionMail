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