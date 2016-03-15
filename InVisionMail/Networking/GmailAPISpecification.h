//
//  GmailAPISpecification.h
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>

// Endpoints
static NSString* const GMAIL_BASE_ADDRESS   = @"https://www.googleapis.com/gmail/v1/users";
static NSString* const MY_MESSAGES          = @"me/messages/";

// Parameter keys
static NSString* const ACCESS_TOKEN_KEY     = @"access_token";
static NSString* const FORMAT_KEY           = @"format";
static NSString* const METADATA_VALUE       = @"metadata";
static NSString* const LABELS_KEY           = @"labelIds";
static NSString* const INBOX_LABEL_VALUE    = @"INBOX";