//
//  ViewController.m
//  InVisionMail
//
//  Created by Vojta Stavik on 12/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "ViewController.h"
#import "APICommunicator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].scopes = @[@"https://www.googleapis.com/auth/gmail.readonly"];
}

- (void) signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (user != nil && error == nil) {
        NSLog(@"User token: %@", user.authentication.accessToken);
        [APICommunicator test:user.authentication.accessToken];
    }
}

@end
