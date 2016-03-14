//
//  AppState.m
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "AppState.h"

@interface AppState ()
@property (readwrite) NSObject<AccessTokenProvider>* tokenProvider;
@end

@implementation AppState

+ (instancetype) sharedState {
    // We use default token provider
    return [self createSharedStateWithTokenProvider:[GoogleAccessTokenProvider new]];
}

+ (instancetype) createSharedStateWithTokenProvider:(NSObject<AccessTokenProvider> *)provider {
    static AppState* sharedState = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedState = [[self alloc] initWithTokenProvider:provider];
    });
    
    return sharedState;
}

- (instancetype) initWithTokenProvider: (NSObject<AccessTokenProvider> *) provider {
    if (self = [super init]) {
        self.tokenProvider = provider;
    }
    return self;
}

- (NSString*) currentUserToken {
    return [self.tokenProvider accessToken];
}

@end
