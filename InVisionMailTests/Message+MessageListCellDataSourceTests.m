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
#import "NSDate+Helpers.h"
#import "MessageTimeFormatter.h"

// Expose private properties and functions needed for testing
@interface Message (Private)
- (NSString*) timestampStringWithTodaysDate: (NSDate*)date;
@end


SPEC_BEGIN(Message_MessageListCellDataSourceTests)

describe(@"Message", ^{
    
    __block TestCoreDataStack* coreDataStack;
    __block Message* message;
    
    beforeEach(^{
        coreDataStack = [TestCoreDataStack new];
        message = [Message findOrCreateElementWithId:@"Episode III" context:coreDataStack.mainContext];
        message.timestamp = 123456;
    });
    
    context(@"when sender is '\"Obi-Wan Kenobi\" <obiwan@kenobi.sw>'", ^{
        beforeEach(^{
            message.sender = @"\"Obi-Wan Kenobi\" <obiwan@kenobi.sw>";
        });
        
        it(@"should return 'Obi-Wan Kenobi' as 'Name'", ^{
            [[message.name should] equal:@"Obi-Wan Kenobi"];
        });
    });
    
    describe(@"data format", ^{
        it(@"should use MessageDateFormatter for timestamp formatting", ^{
            __block NSDate* date;
            __block NSDate* referenceDate;
            __block NSTimeZone* timeZone;
            __block NSLocale* locale;
            
            [MessageTimeFormatter stub:@selector(timestampStringForDate:referenceDate:timeZone:locale:) withBlock:^id(NSArray *params) {
                date = params[0];
                referenceDate = params[1];
                timeZone = params[2];
                locale = params[3];
                return nil;
            }];
            
            NSString* __unused formattedTime = [message timestampString]; // we need to invoke the function
            
            [[expectFutureValue(date) should] equal:[NSDate dateWithTimeIntervalSince1970:message.timestamp]];
            
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            dateFormater.timeZone = timeZone;
            [dateFormater setDateFormat:@"yyyy-MM-dd"];
            [[expectFutureValue([dateFormater stringFromDate:referenceDate]) should] equal:[dateFormater stringFromDate:[NSDate date]]];

            [[expectFutureValue(timeZone) should] equal:[NSTimeZone localTimeZone]];

            [[expectFutureValue(locale) should] equal:[NSLocale currentLocale]];
        });
    });

});

SPEC_END