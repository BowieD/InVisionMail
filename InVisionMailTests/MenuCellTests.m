//
//  MenuCellTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "MenuCell.h"

SPEC_BEGIN(MenuCellTests)

describe(@"MenuCell", ^{
    
    __block MenuCell* cell;
    
    beforeEach(^{
        cell = (MenuCell*)[[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] firstObject];
    });
    
    it(@"should be load from nib properly", ^{
        [[cell shouldNot] beNil];
        [[cell should] beKindOfClass:[MenuCell class]];
    });
    
    describe(@"title label", ^{
        __block UILabel* label;
        
        beforeEach(^{
            label = cell.titleLabel;
        });
        
        it(@"should exist", ^{
            [[label shouldNot] beNil];
        });
    });

//    describe(@"unread mark", ^{
//        __block UIView* mark;
//        
//        beforeEach(^{
//            mark = cell.unreadMark;
//        });
//        
//        it(@"should exist", ^{
//            [[mark shouldNot] beNil];
//        });
//        
//        it(@"should be visible when message is unread", ^{
//            NSObject<MessageListCellDataSource>* dataSource = [KWMock mockForProtocol:@protocol(MessageListCellDataSource)];
//            [dataSource stub:@selector(unread) andReturn:theValue(YES)];
//            [dataSource stub:@selector(name) andReturn:@"The Emperor"];
//            [dataSource stub:@selector(subject) andReturn:@"Return of the Jedi"];
//            [dataSource stub:@selector(snippet) andReturn:@"Now, young Skywalker… you will die."];
//            [dataSource stub:@selector(timestampString) andReturn:@"1977000"];
//            
//            [cell loadData:dataSource];
//            
//            [[theValue(mark.hidden) should] beFalse];
//        });
//    });

    
    it(@"should reset all outlets to the default state when prepareForReuse is called", ^{
        [cell prepareForReuse];
        
        [[cell.titleLabel.text should] beNil];
    });
});

SPEC_END