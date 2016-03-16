//
//  main.m
//  InVisionMail
//
//  Created by Vojta Stavik on 12/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TestingAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        BOOL isTesting = NSClassFromString(@"XCTestCase") != Nil;
        Class appDelegateClass = isTesting ? [TestingAppDelegate class] : [AppDelegate class];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}