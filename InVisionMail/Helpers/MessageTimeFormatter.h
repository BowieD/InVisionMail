//
//  MessageTimeFormatter.h
//  InVisionMail
//
//  Created by Vojta Stavik on 19/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTimeFormatter : NSObject

/**
 Returns formated timestamp for the message. Date format is based on the current user NSLocale
 */
+ (NSString*) timestampStringForDate: (NSDate*)date referenceDate: (NSDate*)today timeZone: (NSTimeZone*)timeZone;

/**
 Returns formated timestamp for the message.
 */
+ (NSString*) timestampStringForDate: (NSDate*)date referenceDate: (NSDate*)today timeZone: (NSTimeZone*)timeZone locale: (NSLocale*)locale;

@end
