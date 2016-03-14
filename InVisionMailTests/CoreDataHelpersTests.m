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
        message = [Message findOrCreateElementWithId:@"some id" context: dataStack.mainContext];
    });
    
    it(@"should create new entity", ^{
        [[message shouldNot] beNil];
    });

    it(@"should assign correct id", ^{
        [[message.customId should] equal:@"some id"];
    });
});

SPEC_END