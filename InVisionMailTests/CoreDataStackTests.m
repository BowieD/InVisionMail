//
//  CoreDataStackTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "CoreDataStack.h"

SPEC_BEGIN(CoreDataStackTests)

describe(@"Core Data Stack", ^{
    __block CoreDataStack* stack;
    
    beforeEach(^{
        stack = [CoreDataStack sharedInstance];
    });
    
    it(@"should create managed object context", ^{
        [[stack.mainContext shouldNot] beNil];
    });

    it(@"should create sync managed object context", ^{
        [[stack.syncContext shouldNot] beNil];
        [[stack.syncContext.parentContext should] equal:stack.mainContext];
    });

});

SPEC_END