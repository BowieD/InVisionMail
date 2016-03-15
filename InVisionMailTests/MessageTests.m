//
//  MessageTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "Message.h"
#import "TestCoreDataStack.h"
#import "NSManagedObject+Helpers.h"

SPEC_BEGIN(MessageTests)

describe(@"Message", ^{
    __block TestCoreDataStack* testStack;
    __block Message* message;
    
    beforeEach(^{
        testStack = [TestCoreDataStack new];
        message = [Message findOrCreateElementWithId:@"Luke" context:testStack.mainContext];
    });
    
    it(@"should load all data from JSON", ^{
        NSDictionary* json = @{
                               @"internalDate": @"1234",
                               @"threadId": @"EpisodeIV",
                               @"historyId": @"1997",
                               @"snippet": @"When 900 years old, you reach… Look as good, you will not."
                               };
        [message loadData:json];
        
        [[theValue(message.timestamp) should] equal:theValue(1234)];
        [[message.threadId should] equal:@"EpisodeIV"];
        [[message.historyId should] equal:@"1997"];
        [[message.snippet should] equal:@"When 900 years old, you reach… Look as good, you will not."];
    });
});

SPEC_END