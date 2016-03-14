//
//  Message.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "Message.h"

@implementation Message

@dynamic customId;

@dynamic timestamp;
@dynamic threadId;
@dynamic historyId;
@dynamic snippet;

- (void) loadData: (NSDictionary *)jsonData {
    
    // JSON keys:
    static NSString* const THREAD_ID_KEY    = @"threadId";
    static NSString* const SNIPPET_KEY      = @"snippet";
    static NSString* const TIMESTAMP_KEY    = @"internalDate";
    static NSString* const HISTORY_ID_KEY   = @"historyId";
    
    id threadId = [jsonData objectForKey:THREAD_ID_KEY];
    if ([threadId isKindOfClass:[NSString class]]) {
        self.threadId = (NSString *)threadId;
    }

    id snippet = [jsonData objectForKey:SNIPPET_KEY];
    if ([snippet isKindOfClass:[NSString class]]) {
        self.snippet = (NSString *)snippet;
    }

    id historyId = [jsonData objectForKey:HISTORY_ID_KEY];
    if ([historyId isKindOfClass:[NSString class]]) {
        self.historyId = (NSString *)historyId;
    }
    
    id timestamp = [jsonData objectForKey:TIMESTAMP_KEY];
    if ([timestamp isKindOfClass:[NSNumber class]]) {
        self.timestamp = [(NSNumber*)timestamp doubleValue];
    }
}

@end
