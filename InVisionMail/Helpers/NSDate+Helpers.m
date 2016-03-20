//
//  NSDate+Helpers.m
//  Created by Vojta Stavik on 19/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

-(NSDate*) dateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    return [self dateWithHour:hour minute:minute second:second timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}

/**
 Returns a new NSDate object with the time set to the indicated hour,
 */
-(NSDate*) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
                timeZone:(NSTimeZone *)timeZone {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timeZone;
    NSDateComponents *components = [calendar components: NSCalendarUnitYear|
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitDay fromDate:self];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}


-(NSInteger) hours {
    return [self hoursForTimezone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}

-(NSInteger) hoursForTimezone: (NSTimeZone*) timeZone {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timeZone;
    return [calendar component:NSCalendarUnitHour fromDate:self];
}


-(NSInteger) minutes {
    return [self minutesForTimezone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}

-(NSInteger) minutesForTimezone: (NSTimeZone*) timeZone {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timeZone;
    return [calendar component:NSCalendarUnitMinute fromDate:self];
}


-(NSInteger) seconds {
    return [self secondsForTimezone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}

-(NSInteger) secondsForTimezone: (NSTimeZone*) timeZone {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timeZone;
    return [calendar component:NSCalendarUnitSecond fromDate:self];
}


-(NSDate*) yesterday {
    return [self dateNumberOfDaysAgo:1];
}

-(NSDate*) dateNumberOfDaysAgo: (NSInteger)numberOfDaysAgo {
    NSDateComponents* components = [[NSDateComponents alloc] init];
    [components setDay:-numberOfDaysAgo];
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

@end
