//
//  MessageTimeFormatter.m
//  InVisionMail
//
//  Created by Vojta Stavik on 19/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageTimeFormatter.h"
#import "NSDate+Helpers.h"

@implementation MessageTimeFormatter

+ (NSString*) timestampStringForDate: (NSDate*)date referenceDate: (NSDate*)today timeZone:(NSTimeZone*) timeZone {
    return [[self class] timestampStringForDate:date referenceDate:today timeZone:timeZone locale:[NSLocale currentLocale]];
}

+ (NSString*) timestampStringForDate: (NSDate*)date referenceDate: (NSDate*)today timeZone:(NSTimeZone*) timeZone locale: (NSLocale*)locale {
    NSLog(@"%@ %@", date.description, today.description);
    
    if ([self datesAreTheSameDate:date date2:today timeZone:timeZone]) {
        // return time
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)[date hoursForTimezone:timeZone], (long)[date minutesForTimezone:timeZone]];
    }
    
    if ([self dateIsYesterday:date today:today timeZone:timeZone]) {
        return @"Yesterday";
    }
    
    if ([self dateIsWithinTheLastWeek:date today:today]) {
        // return name of the day
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        dateFormatter.locale = locale;
        return [dateFormatter stringFromDate:date];
    }
    
    // Date is more than a week ago - we just return short date format
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    formatter.dateStyle = NSDateFormatterShortStyle;

    return [formatter stringFromDate:date];
}

+ (BOOL) datesAreTheSameDate: (NSDate*) date1 date2: (NSDate*) date2 timeZone: (NSTimeZone*)timeZone {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.timeZone = timeZone;
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    return [[dateFormater stringFromDate:date1] isEqualToString:[dateFormater stringFromDate:date2]];
}

+ (BOOL) dateIsYesterday: (NSDate*) date today: (NSDate*) today timeZone: (NSTimeZone*)timeZone {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.timeZone = timeZone;
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* yesterday = [today yesterday];
    
    return [[dateFormater stringFromDate:date] isEqualToString:[dateFormater stringFromDate:yesterday]];
}

+ (BOOL) dateIsWithinTheLastWeek: (NSDate*) date today: (NSDate*) today {
    return [date compare:[today dateNumberOfDaysAgo:7]] == NSOrderedDescending;
}


@end