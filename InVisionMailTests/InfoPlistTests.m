//
//  InfoPlistTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>

SPEC_BEGIN(InfoPlistTests)

describe(@"Info Plist", ^{
    __block NSDictionary* pListDictionary;
    
    beforeEach(^{
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Info" ofType: @"plist"];
        pListDictionary =[[NSDictionary alloc] initWithContentsOfFile:path];
    });
});

SPEC_END