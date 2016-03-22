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

SPEC_BEGIN(SignInVCTests)

describe(@"SignIn controller", ^{
    __block SignInVC* signInVC;
    
    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        signInVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SignInVC"];
        UIView* view __unused = signInVC.view; // load view
    });
    
//    it(@"should be embeded in NavigationController", ^{
//        UINavigationController* v = signInVC.navigationController;
//        [[signInVC.navigationController shouldNot] beNil];
//    });
    
    it(@"shoud show DrawerVC when SignIn is successfull", ^{
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
        
        [[expectFutureValue(theValue([destinationVC isKindOfClass:[DrawerVC class]])) shouldEventually] beTrue];
    });
});

SPEC_END