//
//  Message.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "Message.h"
#import "NSString+Base64URL.h"

@implementation Message

@dynamic customId;

@dynamic timestamp;
@dynamic threadId;
@dynamic historyId;
@dynamic snippet;
@dynamic subject;
@dynamic sender;
@dynamic body;
@dynamic unread;


// JSON keys:
static NSString* const THREAD_ID_KEY    = @"threadId";
static NSString* const SNIPPET_KEY      = @"snippet";
static NSString* const TIMESTAMP_KEY    = @"internalDate";
static NSString* const HISTORY_ID_KEY   = @"historyId";
static NSString* const PAYLOAD_KEY      = @"payload";
static NSString* const HEADERS_KEY      = @"headers";
static NSString* const BODY_KEY         = @"body";
static NSString* const DATA_KEY         = @"data";
static NSString* const HEADER_NAME_KEY  = @"name";
static NSString* const HEADER_VALUE_KEY = @"value";
static NSString* const FROM_KEY         = @"From";
static NSString* const SUBJECT_KEY      = @"Subject";
static NSString* const LABELS_KEY       = @"labelIds";
static NSString* const UNREAD_LABEL     = @"UNREAD";
static NSString* const PARTS_KEY        = @"parts";

static NSString* const CONTENT_TYPE_VALUE = @"Content-Type";
static NSString* const TEXT_PLAIN_VALUE = @"text/plain";

- (void) loadData: (NSDictionary *)jsonData {
    
    // NOTE:
    // In a real project, I wouldn't do this manually. I would use some library
    // for more confortable and readable JSON parsing.
    
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

        // Subject + Sender
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
        
        // Message body
        id parts = [payload objectForKey:PARTS_KEY];
        if ([parts isKindOfClass:[NSArray class]]) {
            
            // Find a body with text/plain Content-Type header
            for (NSDictionary* part in (NSArray*)parts) {
                if ([part isKindOfClass:[NSDictionary class]]) {
                    NSArray* headers = [part objectForKey:HEADERS_KEY];
                    
                    if ([headers isKindOfClass:[NSArray class]]) {
                        if ([self containsTextPlainHeader:headers]) {
                            // Founded!
                            NSDictionary* body = [part objectForKey:BODY_KEY];
                            
                            if ([body isKindOfClass:[NSDictionary class]]) {
                                NSString* bodyEncodedString = [body objectForKey:DATA_KEY];
                            
                                if ([bodyEncodedString isKindOfClass:[NSString class]]) {
                                    self.body = [bodyEncodedString base64URLDecodedString];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// Helper function to search through headers to find out, it there is
// Content-Type: text/plain header contained.
- (BOOL) containsTextPlainHeader: (NSArray*)headers {
    BOOL result = NO;
    
    for (NSDictionary* header in headers) {
        NSString* name = [header valueForKey:HEADER_NAME_KEY];
        NSString* value = [header valueForKey:HEADER_VALUE_KEY];
        
        if ([name isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            if ([name isEqualToString:CONTENT_TYPE_VALUE]
                && [value containsString:TEXT_PLAIN_VALUE])
            {
                result = YES;
            }
        }
    }
    
    return result;
}

@end
