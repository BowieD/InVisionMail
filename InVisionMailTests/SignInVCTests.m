//
//  SignInVCTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 16/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "SignInVC.h"
#import "DrawerVC.h"
#import "MainSplitVC.h"

SPEC_BEGIN(SignInVCTests)

describe(@"SignIn controller", ^{
    __block SignInVC* signInVC;
    
    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        signInVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SignInVC"];
        UIView* view __unused = signInVC.view; // load view
    });
    
    it(@"shoud show MainSplitVC when SignIn is successfull", ^{
        __block UIViewController* destinationVC = nil;
        [signInVC stub:@selector(prepareForSegue:sender:) withBlock:^id(NSArray *params) {
            UIStoryboardSegue* segue = (UIStoryboardSegue*)params[0];
            destinationVC = segue.destinationViewController;
            return nil; // because of compiler
        }];
        
        GIDGoogleUser* mockUser = [GIDGoogleUser mock];
        GIDGoogleUser* mockAuthenticaton = [GIDGoogleUser mock];
        [mockUser stub:@selector(authentication) andReturn:mockAuthenticaton];
        [mockAuthenticaton stub:@selector(accessToken) andReturn:@"LukeAndLeia"];
        
        [signInVC signIn:nil didSignInForUser:mockUser withError:nil];
        
        [[expectFutureValue(theValue([destinationVC isKindOfClass:[MainSplitVC class]])) shouldEventually] beTrue];
    });
});

SPEC_END