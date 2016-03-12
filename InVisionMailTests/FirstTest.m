//
//  FirstTest.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>

SPEC_BEGIN(FirstTest)

describe(@"First Test", ^{
    it(@"should fail", ^{
        [[theValue(YES) should] beFalse];
    });
});

SPEC_END