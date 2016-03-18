//
//  NSString+RemoveSubstring.m
//  InVisionMail
//
//  Created by Vojta Stavik on 18/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "NSString+RemoveSubstring.h"

@implementation NSString (RemoveSubstring)

- (nullable NSString*) removeSubstringBetweenStartString: (NSString* _Nonnull)startString
                                            andEndString: (NSString* _Nonnull) endString
                                       includeBoundaries: (BOOL) includeBoundaries {

    NSRange start = [self rangeOfString:startString];
    if (start.location == NSNotFound) {
        return self;
    }

    NSRange end = [self rangeOfString:endString];
    if (end.location == NSNotFound) {
        return self;
    }
    
    unsigned long startIndex;
    unsigned long endIndex;
    
    if (includeBoundaries) {
        startIndex = start.location;
        endIndex = end.location + end.length;
    } else {
        startIndex = start.location + start.length;
        endIndex = end.location;
    }
    
    return [self stringByReplacingCharactersInRange:NSMakeRange(startIndex , endIndex - startIndex) withString:@""];
}

@end
