//
//  NSDateHelpersTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 19/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "NSDate+Helpers.h"

SPEC_BEGIN(NSDateHelpersTests)

describe(@"NSDate helpers", ^{
    
    __block NSDate* date;
    
    beforeEach(^{
        // 1458389470 -> Sat Mar 19 12:11:10 2016 GMT
        date = [NSDate dateWithTimeIntervalSince1970:1458389470];
    });
    
    it(@"should set time componets for date", ^{
        date = [date dateWithHour:8 minute:7 second:6 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        NSCalendar* gmtCalendar = [NSCalendar currentCalendar];
        gmtCalendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        [[theValue([gmtCalendar component:NSCalendarUnitHour fromDate:date]) should] equal:theValue(8)];
        [[theValue([gmtCalendar component:NSCalendarUnitMinute fromDate:date]) should] equal:theValue(7)];
        [[theValue([gmtCalendar component:NSCalendarUnitSecond fromDate:date]) should] equal:theValue(6)];
    });
    
    it(@"should return hours, minutes and seconds", ^{
        [[theValue([date hoursForTimezone:[NSTimeZone timeZoneForSecondsFromGMT:0]]) should] equal:theValue(12)];
        [[theValue([date minutesForTimezone:[NSTimeZone timeZoneForSecondsFromGMT:0]]) should] equal:theValue(11)];
        [[theValue([date secondsForTimezone:[NSTimeZone timeZoneForSecondsFromGMT:0]]) should] equal:theValue(10)];
    });
    
    it(@"shoul return previous day for yesterday", ^{
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        [[[dateFormater stringFromDate:date] should] equal:@"2016-03-19"];
        [[[dateFormater stringFromDate:[date yesterday]] should] equal:@"2016-03-18"];
    });
    
    it(@"shoul return the day 5 days ago", ^{
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        [[[dateFormater stringFromDate:date] should] equal:@"2016-03-19"];
        [[[dateFormater stringFromDate:[date dateNumberOfDaysAgo:5]] should] equal:@"2016-03-14"];
    });
});

SPEC_END
