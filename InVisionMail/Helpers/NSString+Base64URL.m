//
//  NSString+Base64URL.m
//  InVisionMail
//
//  Created by Vojta Stavik on 25/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "NSString+Base64URL.h"

@implementation NSString (Base64URL)

- (NSString*) base64URLDecodedString {

    NSData* data = [[NSData alloc] initWithBase64EncodedString:[self base64String] options:0];

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString*) base64String {
    // Convert Base64URL string to Base64

    // Replace invalid characters
    NSString* tempString = [self stringByReplacingOccurrencesOfString:@"-" withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    
    tempString = [tempString stringByReplacingOccurrencesOfString:@"_" withString:@"/" options:NSLiteralSearch range:NSMakeRange(0, [tempString length])];

    // Add '='
    int numberOfChars = self.length % 4;
    for (int i = 0; i < numberOfChars; i++) {
        tempString = [tempString stringByAppendingString:@"="];
    }
    
    return tempString;
}

@end
