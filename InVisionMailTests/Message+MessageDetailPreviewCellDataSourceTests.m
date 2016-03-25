//
//  Message+MessageDetailPreviewCellDataSourceTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 25/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "NSManagedObject+Helpers.h"
#import "Message+MessageDetailPreviewCellDataSource.h"
#import "TestCoreDataStack.h"
#import "NSDate+Helpers.h"
#import "MessageTimeFormatter.h"


SPEC_BEGIN(Message_MessageDetailPreviewCellDataSourceTests)

describe(@"Message", ^{
    
    __block TestCoreDataStack* coreDataStack;
    __block Message* message;
    
    beforeEach(^{
        coreDataStack = [TestCoreDataStack new];
        message = [Message findOrCreateElementWithId:@"Episode III" context:coreDataStack.mainContext];
    });
    
    it(@"should return default avatar image", ^{
        [[[message avatarImage] should] equal:[UIImage imageNamed:@"avatar-placeholder"]];
    });

});

SPEC_END