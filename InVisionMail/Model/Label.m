//
//  Label.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "Label.h"

@implementation Label

@dynamic customId;
@dynamic title;
@dynamic category;
@dynamic order;

- (void) loadData: (NSDictionary *)jsonData {
    
    // JSON keys & values:
    static NSString* const NAME_KEY = @"name";
    static NSString* const CATEGORY_PREFIX = @"category";
    static NSString* const NAME_CATEGORY_PREFIX = @"CATEGORY_";

    if ([[self.customId uppercaseString] hasPrefix:[CATEGORY_PREFIX uppercaseString]]) {
        self.category = GROUPS_CATEGORY;
    } else {
        self.category = MAILBOXES_CATEGORY;
    }
    
    id name = [jsonData objectForKey:NAME_KEY];
    if ([name isKindOfClass:[NSString class]]) {
        if ([self.category isEqual:GROUPS_CATEGORY]) {
            // remove CATEGORY_ prefix from name
            self.title = [(NSString*)name stringByReplacingOccurrencesOfString:NAME_CATEGORY_PREFIX withString:@""];
        } else {
            self.title = (NSString *)name;
        }
        
        if ([[self.title uppercaseString] isEqualToString:@"INBOX"]) {
            // A small hack to have Inbox label at the first place.
            // In the real world project, the order of the label would
            // be handle on the server side.
            self.order = 1;
        } else {
            self.order = INT16_MAX;
        }
    }
    
}

@end
