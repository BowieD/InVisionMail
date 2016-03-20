//
//  MessageTimeFormatterTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 19/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "NSDate+Helpers.h"
#import "MessageTimeFormatter.h"


SPEC_BEGIN(MessageTimeFormatterTests)

describe(@"MessageTimeFormatter", ^{
    
    __block NSDate* referenceToday;
    __block NSTimeZone* gmtTimeZone;
    __block NSLocale* usLocale;
    __block NSDate* date;
    
    beforeEach(^{
        // we use artifitial "today" date to be sure tests work without any external effects
        referenceToday = [NSDate dateWithTimeIntervalSince1970:1000000000]; // Sun, 09 Sep 2001 01:46:40 GMT
        gmtTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        usLocale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    });
    
    context(@"when the date is today", ^{
        
        beforeEach(^{
            date = [referenceToday dateWithHour:12 minute:11 second:10];
        });
        
        it(@"should show just time", ^{
            [[[MessageTimeFormatter timestampStringForDate:date referenceDate:referenceToday timeZone: gmtTimeZone] should] equal:@"12:11"];
        });
    });
    
    context(@"when the date is yesterday", ^{
        
        beforeEach(^{
            date = [[referenceToday dateWithHour:12 minute:11 second:10] yesterday];
        });
        
        it(@"should say 'Yesterday'", ^{
            [[[MessageTimeFormatter timestampStringForDate:date referenceDate:referenceToday timeZone: gmtTimeZone] should] equal:@"Yesterday"];
        });
    });
    
    context(@"when the date is within the last week", ^{

        beforeEach(^{
            date = [referenceToday dateNumberOfDaysAgo:5]; // Sunday - 5 days -> Tuesday
        });
        
        it(@"should return the name of the day", ^{
            NSString* formattedTimestamp = [MessageTimeFormatter timestampStringForDate:date referenceDate:referenceToday timeZone:gmtTimeZone locale:usLocale];
            [[formattedTimestamp should] equal:@"Tuesday"];
        });
    });
    
    context(@"when the date is more then a week ago", ^{
        beforeEach(^{
            date = [referenceToday dateNumberOfDaysAgo:8]; // Sat, 01 Sep 2001 01:46:40 GMT
        });
        
        it(@"should return short formated date", ^{
            NSString* formattedTimestamp = [MessageTimeFormatter timestampStringForDate:date referenceDate:referenceToday timeZone:gmtTimeZone locale:usLocale];
            [[formattedTimestamp should] equal:@"9/1/01"];
        });
    });
});

SPEC_END