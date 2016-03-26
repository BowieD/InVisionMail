//
//  Message+MessageListCellDataSource.m
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "Message+MessageListCellDataSource.h"
#import "NSString+RemoveSubstring.h"
#import "MessageTimeFormatter.h"

@implementation Message (MessageListCellDataSource)

- (NSString*) name {
    // Remove raw email address <email>
    NSString* name = [self.sender removeSubstringBetweenStartString:@"<" andEndString:@">" includeBoundaries:YES];
    
    // Remove "
    name = [name stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    // Remove leading and trailing whitespace
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return name;
}

- (NSString*) timestampString {
    if (self.timestamp == 0) {
        return nil;
    } else {
        return [self timestampStringWithTodaysDate:[NSDate date]];
    }
}

- (NSString*) timestampStringWithTodaysDate: (NSDate*)date {
    return [MessageTimeFormatter timestampStringForDate:[NSDate dateWithTimeIntervalSince1970:self.timestamp]
                                          referenceDate:date
                                               timeZone:[NSTimeZone localTimeZone]];
}

@end
