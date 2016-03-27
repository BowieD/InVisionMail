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
#import "UIFont+AppFonts.h"

@interface SignInVC ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoCenterYConstraint;

@end


@implementation SignInVC
// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
    [self setupSignInButton];
    [self setupActivityIndicator];
    [self setupStatusLabel];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animateIntro];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupAppearance {
    self.statusLabel.alpha = 0;
    self.signInButton.alpha = 0;
}

- (void) setupSignInButton {
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].scopes = @[GMAIL_READONLY_SCOPE];
    
    [self.signInButton addTarget:self action:@selector(didTapOnSignInButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setupActivityIndicator {
    self.activityIndicator.hidesWhenStopped = YES;
}

- (void) setupStatusLabel {
    self.statusLabel.font = [UIFont regularTextFont_Regular];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.text = @"Please sign in with your Gmail account.";
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Actions

- (void) animateIntro {
    [UIView animateWithDuration:1.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.logoCenterYConstraint.constant = - 80;
        
        self.captionLabel.alpha = -3; // to make it disappear quicker
        self.statusLabel.alpha = 1;
        self.signInButton.alpha = 1;
        
        [self.view layoutIfNeeded];
        
    } completion:nil];
}

- (void) didTapOnSignInButton: (GIDSignInButton*)sender {
    // We handle just the activity indicator here. The actual
    // sign is handled by the button itself.
    [self.activityIndicator startAnimating];
}



// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - GoogleSignIn delegate

- (void) signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    [self.activityIndicator stopAnimating];
    
    if (user != nil && error == nil) {
        NSLog(@"User token: %@", user.authentication.accessToken);
        [self performSegueWithIdentifier:SHOW_INBOX sender:self];
    } else {
        // Show error
        self.statusLabel.text = error.localizedDescription;
    }
}

@end
