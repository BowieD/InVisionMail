//
//  NSDate+Helpers.h
//  InVisionMail
//
//  Created by Vojta Stavik on 19/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

-(NSDate *) dateWithHour: (NSInteger)hour
                  minute: (NSInteger)minute
                  second: (NSInteger)second;

-(NSDate *) dateWithHour: (NSInteger)hour
                  minute: (NSInteger)minute
                  second: (NSInteger)second
                timeZone: (NSTimeZone*)timeZone;


// For GMT timezone
-(NSInteger) hours;
-(NSInteger) minutes;
-(NSInteger) seconds;

-(NSInteger) hoursForTimezone: (NSTimeZone*)timeZone;
-(NSInteger) minutesForTimezone: (NSTimeZone*)timeZone;
-(NSInteger) secondsForTimezone: (NSTimeZone*)timeZone;

-(NSDate*) yesterday;
-(NSDate*) dateNumberOfDaysAgo: (NSInteger)numberOfDaysAgo;

@end
