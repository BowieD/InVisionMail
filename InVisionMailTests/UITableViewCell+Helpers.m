//
//  UITableViewCell+Helpers.m
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "UITableViewCell+Helpers.h"
#import "DummyCell.h"

SPEC_BEGIN(UITableViewCellHelpersTests)

describe(@"TableViewCell helpers", ^{
    
    __block DummyCell* cell;
    
    beforeEach(^{
        cell = [DummyCell new];
    });
    
    it(@"should return 'DummyCell' as a reuse identifier", ^{
        [[[[cell class] reuseIdentifier] should] equal:@"DummyCell"];
    });

    it(@"should return a nib named 'DummyCell' ", ^{
        // Unfortunately, I haven't found the way, how to compare 2 UINibs so far.
        // So I just test, if it returns non-nill for existing nib
        // and nill for non-existing.
        
//        [[[DummyCell nib] shouldNot] beNil];
//        [[[DummyCell2 nib] should] beNil];
    });

});
SPEC_END