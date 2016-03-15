//
//  CoreDataHelpersTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "Message.h"
#import "NSManagedObject+Helpers.h"
#import "TestCoreDataStack.h"

SPEC_BEGIN(CoreDataHelpersTests)

describe(@"Managed object", ^{
    
    __block TestCoreDataStack* dataStack;
    __block Message* message;
    
    beforeEach(^{
        dataStack = [TestCoreDataStack new];
        message = [Message findOrCreateElementWithId:@"LukeLeia" context: dataStack.mainContext];
    });
    
    it(@"should create new entity", ^{
        [[message shouldNot] beNil];
    });

    it(@"should assign correct id", ^{
        [[message.customId should] equal:@"LukeLeia"];
    });
    
    it(@"should fetch existing entity by customId", ^{
        assert(message != nil);
        [[[Message withCustomId:@"LukeLeia" fromContext:dataStack.mainContext] shouldNot] beNil];
    });
    
    context(@"when entity doesn't exist", ^{
        it(@"should create it and load data from JSON to it", ^{
            NSDictionary* dummyMessageJSONData = @{
                                                   @"internalDate": @"1234",
                                                   @"threadId": @"EpisodeIV",
                                                   @"historyId": @"1997",
                                                   @"snippet": @"When 900 years old, you reach… Look as good, you will not."
                                                   };
            
            [Message loadFromJSON:dummyMessageJSONData customId:@"HanSolo" context:dataStack.mainContext completionBlock:nil];

            // Because loadFromJSON is asynchronous, we have to use async testing
            [[expectFutureValue(theValue([Message withCustomId:@"HanSolo" fromContext:dataStack.mainContext].timestamp))
              shouldEventually] equal:theValue(1234)];
            
            [[expectFutureValue([Message withCustomId:@"HanSolo" fromContext:dataStack.mainContext].threadId)
              shouldEventually] equal:@"EpisodeIV"];
            
            [[expectFutureValue([Message withCustomId:@"HanSolo" fromContext:dataStack.mainContext].historyId)
              shouldEventually] equal:@"1997"];
            
            [[expectFutureValue([Message withCustomId:@"HanSolo" fromContext:dataStack.mainContext].snippet)
              shouldEventually] equal:@"When 900 years old, you reach… Look as good, you will not."];
        });
    });
    
    context(@"when entity exist", ^{
        it(@"should update it by the data from JSON", ^{
            NSDictionary* dummyMessageJSONData = @{
                                                   @"internalDate": @"1234",
                                                   @"threadId": @"EpisodeIV",
                                                   @"historyId": @"1997",
                                                   @"snippet": @"When 900 years old, you reach… Look as good, you will not."
                                                   };
            
            [Message loadFromJSON:dummyMessageJSONData customId:@"LukeLeia" context:dataStack.mainContext completionBlock:nil];
            
            // Because loadFromJSON is asynchronous, we have to use async testing
            [[expectFutureValue(theValue([Message withCustomId:@"LukeLeia" fromContext:dataStack.mainContext].timestamp))
              shouldEventually] equal:theValue(1234)];
            
            [[expectFutureValue([Message withCustomId:@"LukeLeia" fromContext:dataStack.mainContext].threadId)
              shouldEventually] equal:@"EpisodeIV"];
            
            [[expectFutureValue([Message withCustomId:@"LukeLeia" fromContext:dataStack.mainContext].historyId)
              shouldEventually] equal:@"1997"];
            
            [[expectFutureValue([Message withCustomId:@"LukeLeia" fromContext:dataStack.mainContext].snippet)
              shouldEventually] equal:@"When 900 years old, you reach… Look as good, you will not."];
        });
    });
});

SPEC_END