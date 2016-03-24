//
//  MainSplitVCTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "MainSplitVC.h"
#import "DrawerVC.h"
#import "MessageDetailVC.h"

SPEC_BEGIN(MainSplitVCTests)

describe(@"MainSplitVC", ^{
    __block MainSplitVC* splitVC;
    
    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        splitVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainSplitVC"];
        
        UIView* view __unused = [splitVC view]; // load view
    });
    
    it(@"should have DrawerVC as the master controller", ^{
        [[splitVC.viewControllers.firstObject should] beKindOfClass:[DrawerVC class]];
    });
    
    it(@"should have UINavigationController with MessageDetailVC as the detail controller", ^{
        UINavigationController* navCon = splitVC.viewControllers[1];
        [[navCon.viewControllers.firstObject should] beKindOfClass:[MessageDetailVC class]];
    });
    
    it(@"should have preferredDisplayMode set to UISplitViewControllerDisplayModeAllVisible", ^{
        [[theValue(splitVC.preferredDisplayMode) should] equal:theValue(UISplitViewControllerDisplayModeAllVisible)];
    });
});

SPEC_END