//
//  MenuCellTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "MenuCell.h"


// Expose private functions needed for testing
@interface MenuCell (Private)
@property (nonatomic, weak) UILabel* titleLabel;
@end


SPEC_BEGIN(MenuCellTests)

describe(@"MenuCell", ^{
    
    __block MenuCell* cell;
    
    beforeEach(^{
        cell = (MenuCell*)[[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] firstObject];
    });
    
    it(@"should be load from nib properly", ^{
        [[cell shouldNot] beNil];
        [[cell should] beKindOfClass:[MenuCell class]];
    });
    
    describe(@"title label", ^{
        __block UILabel* label;
        
        beforeEach(^{
            label = cell.titleLabel;
        });
        
        it(@"should exist", ^{
            [[label shouldNot] beNil];
        });
    });
    
    it(@"should reset all outlets to the default state when prepareForReuse is called", ^{
        [cell prepareForReuse];
        
        [[cell.titleLabel.text should] beNil];
    });
});

SPEC_END