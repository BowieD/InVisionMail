//
//  NSString+RemoveSubstringTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 18/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "NSString+RemoveSubstring.h"

SPEC_BEGIN(NSString_RemoveSubstringTests)

describe(@"Remove substring helper", ^{
    
    __block NSString* originalString;
    
    beforeEach(^{
        originalString = @"Test <\"Test\">";
    });
    
    context(@"when startString doesn't exists", ^{
       it(@"should return original string", ^{
           NSString* modifiedStringWithoutBoundaries = [originalString removeSubstringBetweenStartString:@"&" andEndString:@">" includeBoundaries:YES];
           [[modifiedStringWithoutBoundaries should] equal:@"Test <\"Test\">"];
           
           NSString* modifiedStringWithBoundaries = [originalString removeSubstringBetweenStartString:@"&" andEndString:@">" includeBoundaries:NO];
           [[modifiedStringWithBoundaries should] equal:@"Test <\"Test\">"];
       });
    });
    
    context(@"when endString doesn't exists", ^{
        it(@"should return original string", ^{
            NSString* modifiedStringWithoutBoundaries = [originalString removeSubstringBetweenStartString:@"<" andEndString:@"&" includeBoundaries:YES];
            [[modifiedStringWithoutBoundaries should] equal:@"Test <\"Test\">"];
            
            NSString* modifiedStringWithBoundaries = [originalString removeSubstringBetweenStartString:@"<" andEndString:@"&" includeBoundaries:NO];
            [[modifiedStringWithBoundaries should] equal:@"Test <\"Test\">"];
        });
    });
    
    context(@"when start and end string exists", ^{
        it(@"should remove substring between given strings", ^{
            NSString* modifiedStringWithoutBoundaries = [originalString removeSubstringBetweenStartString:@"<" andEndString:@">" includeBoundaries:YES];
            [[modifiedStringWithoutBoundaries should] equal:@"Test "];
            
            NSString* modifiedStringWithBoundaries = [originalString removeSubstringBetweenStartString:@"<" andEndString:@">" includeBoundaries:NO];
            [[modifiedStringWithBoundaries should] equal:@"Test <>"];
        });
    });
});

SPEC_END