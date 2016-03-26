//
//  AppDelegate.m
//  InVisionMail
//
//  Created by Vojta Stavik on 12/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "UIColor+AppColors.h"
#import "UIFont+AppFonts.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"GoogleService-Info" ofType: @"plist"];
    NSDictionary *googleServicePlist =[[NSDictionary alloc] initWithContentsOfFile:path];

    NSString* googleClientID = [googleServicePlist valueForKey:@"CLIENT_ID"];
    [GIDSignIn sharedInstance].clientID = googleClientID;

    [self setupBasicAppearance];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                                       sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupBasicAppearance {
    [[UINavigationBar appearance] setTintColor:[UIColor invision_darkGrayColor]];
}



@end
