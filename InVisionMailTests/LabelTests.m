//
//  LabelTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "Label.h"
#import "TestCoreDataStack.h"
#import "NSManagedObject+Helpers.h"

SPEC_BEGIN(LabelTests)

describe(@"Label", ^{
    __block TestCoreDataStack* testStack;
    __block Label* label;
    
    beforeEach(^{
        testStack = [TestCoreDataStack new];
        label = [Label findOrCreateElementWithId:@"Darth Vader" context:testStack.mainContext];
    });
    
    it(@"should load all data from JSON", ^{
        NSDictionary* json = @{
                               @"id": @"Darth Vader",
                               @"name": @"Anakin Skywalker"
                               };
        
        [label loadData:json];
        
        [[label.title should] equal:@"Anakin Skywalker"];
    });
    
    it(@"should set 'MAILBOXES_CATEGORY' if id doesn't start with CATEGORY", ^{
        NSDictionary* json = @{
                               @"id": @"Darth Vader",
                               @"name": @"Anakin Skywalker"
                               };
        
        label.customId = [json objectForKey:@"id"];
        [label loadData:json];
        
        
        [[label.category should] equal:MAILBOXES_CATEGORY];
    });
    
    context(@"when Label is in the Groups category", ^{
        beforeEach(^{
            NSDictionary* json = @{
                                   @"id": @"CATEGORY Darth Vader",
                                   @"name": @"CATEGORY_Anakin Skywalker"
                                   };
            
            label.customId = [json objectForKey:@"id"];
            [label loadData:json];
        });
        
        it(@"should set 'GROUPS_CATEGORY' if id starts with prefix CATEGORY", ^{
            [[label.category should] equal:GROUPS_CATEGORY];
        });
        
        it(@"should remove the 'CATEGORY_' prefix from name if", ^{
            [[label.title should] equal:@"Anakin Skywalker"];
        });
    });
    

});

SPEC_END