//
//  SubjectHeaderViewTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "SubjectHeaderView.h"

SPEC_BEGIN(SubjectHeaderViewTests)

describe(@"SubjectHeaderView", ^{
    __block SubjectHeaderView* view;
    
    beforeEach(^{
       view = (SubjectHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"SubjectHeaderView" owner:self options:nil] firstObject];
    });
    
    describe(@"title label", ^{
        __block UILabel* titleLabel;
        
        beforeEach(^{
            titleLabel = view.titleLabel;
        });
        
        it(@"should be initialized", ^{
            [[titleLabel shouldNot] beNil];
        });
        
    });
    
    
});

SPEC_END