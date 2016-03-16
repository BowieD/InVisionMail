//
//  SignInVC.m
//  InVisionMail
//
//  Created by Vojta Stavik on 12/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "SignInVC.h"
#import "APICommunicator.h"
#import "GmailAPISpecification.h"
#import "Segues.h"

@interface SignInVC ()
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@end

@implementation SignInVC

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].scopes = @[GMAIL_READONLY_SCOPE];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - GoogleSignIn delegate

- (void) signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (user != nil && error == nil) {
        NSLog(@"User token: %@", user.authentication.accessToken);
        [self performSegueWithIdentifier:SHOW_INBOX sender:self];
    }
}

@end
