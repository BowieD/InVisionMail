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
@dynamic subject;
@dynamic sender;
@dynamic unread;

- (void) loadData: (NSDictionary *)jsonData {
    
    // JSON keys:
    static NSString* const THREAD_ID_KEY    = @"threadId";
    static NSString* const SNIPPET_KEY      = @"snippet";
    static NSString* const TIMESTAMP_KEY    = @"internalDate";
    static NSString* const HISTORY_ID_KEY   = @"historyId";
    static NSString* const PAYLOAD_KEY      = @"payload";
    static NSString* const HEADERS_KEY      = @"headers";
    static NSString* const HEADER_NAME_KEY  = @"name";
    static NSString* const HEADER_VALUE_KEY = @"value";
    static NSString* const FROM_KEY         = @"From";
    static NSString* const SUBJECT_KEY      = @"Subject";
    static NSString* const LABELS_KEY       = @"labelIds";
    static NSString* const UNREAD_LABEL     = @"UNREAD";
    
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
    if ([timestamp isKindOfClass:[NSString class]]) {
        NSString* timestampString = (NSString *)timestamp;
        self.timestamp = timestampString.doubleValue / 1000.f; // Google returns timestamp in miliseconds
    }

    id labels = [jsonData objectForKey:LABELS_KEY];
    if ([labels isKindOfClass:[NSArray class]]) {
        for (NSString* label in (NSArray*)labels) {
            if ([label isEqualToString:UNREAD_LABEL]) {
                self.unread = YES;
            }
        }
    }

    
    id payload = [jsonData objectForKey:PAYLOAD_KEY];
    if ([payload isKindOfClass:[NSDictionary class]]) {
        NSArray* headersArray = [payload objectForKey:HEADERS_KEY];
        if ([headersArray isKindOfClass:[NSArray class]]) {

            // We have to iterate through headers and find the relevant ones
            for (NSDictionary* headerDic in headersArray) {
                if ([headerDic isKindOfClass:[NSDictionary class]]) {
                    NSString* headerName = [headerDic valueForKey:HEADER_NAME_KEY];
                    if ([headerName isKindOfClass:[NSString class]]) {

                        // Sender info header
                        if ([headerName isEqualToString:FROM_KEY]) {
                            NSString* from = [headerDic objectForKey:HEADER_VALUE_KEY];
                            if ([from isKindOfClass:[NSString class]]) {
                                self.sender = from;
                            }
                        }
                        
                        // Subject info header
                        if ([headerName isEqualToString:SUBJECT_KEY]) {
                            NSString* subject = [headerDic objectForKey:HEADER_VALUE_KEY];
                            if ([subject isKindOfClass:[NSString class]]) {
                                self.subject = subject;
                            }
                        }
                    }
                }
            }
        }
    }
}

@end
