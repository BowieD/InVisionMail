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
    });
    
    it(@"should create new entity", ^{
        message = (Message*)[Message findOrCreateElementWithName:@"Message" objectId:@"some id" context: dataStack.mainContext];
        [[message shouldNot] beNil];
    });
});

SPEC_END