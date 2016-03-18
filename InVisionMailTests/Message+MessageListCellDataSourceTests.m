//
//  Message+MessageListCellDataSourceTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 18/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "NSManagedObject+Helpers.h"
#import "Message+MessageListCellDataSource.h"
#import "TestCoreDataStack.h"

SPEC_BEGIN(Message_MessageListCellDataSourceTests)

describe(@"Message", ^{
    
    __block TestCoreDataStack* coreDataStack;
    __block Message* message;
    
    beforeEach(^{
        coreDataStack = [TestCoreDataStack new];
        message = [Message findOrCreateElementWithId:@"Episode III" context:coreDataStack.mainContext];
    });
    
    context(@"when sender is '\"Obi-Wan Kenobi\" <obiwan@kenobi.sw>'", ^{
        beforeEach(^{
            message.sender = @"\"Obi-Wan Kenobi\" <obiwan@kenobi.sw>";
        });
        
        it(@"should return 'Obi-Wan Kenobi' as 'Name'", ^{
            [[message.name should] equal:@"Obi-Wan Kenobi"];
        });
    });

});

SPEC_END