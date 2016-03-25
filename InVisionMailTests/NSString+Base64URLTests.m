//
//  NSString+Base64URLTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 25/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "NSString+Base64URL.h"

SPEC_BEGIN(NSStringBase64URLTests)

describe(@"Base64URL decoder", ^{
    it(@"should decode string", ^{
        NSString* originalString = @"The Force Awakens";
        NSString* encodedString = @"VGhlIEZvcmNlIEF3YWtlbnM";
        
        [[[encodedString base64URLDecodedString] should] equal:originalString];
    });
});

SPEC_END