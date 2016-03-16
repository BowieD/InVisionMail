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
#import "CellFactoryTableView.h"

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

    
    describe(@"unread icon", ^{
        __block UIImageView* icon;
        
        beforeEach(^{
            icon = cell.unreadIcon;
        });
        
        it(@"should exist", ^{
            [[icon shouldNot] beNil];
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
    });
});

SPEC_END