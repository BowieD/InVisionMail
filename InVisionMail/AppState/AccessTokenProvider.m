//
//  AccessTokenProvider.m
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "AccessTokenProvider.h"
#import <GoogleSignIn/GoogleSignIn.h>

@implementation GoogleAccessTokenProvider

- (NSString* _Nullable) accessToken {
    return [GIDSignIn sharedInstance].currentUser.authentication.accessToken;
}

@end

