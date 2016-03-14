//
//  AppStateTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "AppState.h"
#import "AccessTokenProvider.h"

SPEC_BEGIN(AppStateTests)

describe(@"App state", ^{
    describe(@"default shared instance", ^{
        it(@"should have GoogleAccessTokenProvider", ^{
            [[[AppState sharedState].tokenProvider should] beKindOfClass:[GoogleAccessTokenProvider class]];
        });
    });
    
    __block AppState* appState;
    
    beforeEach(^{
        NSObject<AccessTokenProvider>* provider = [KWMock mockForProtocol:@protocol(AccessTokenProvider)];
        [provider stub:@selector(accessToken) andReturn:@"A long time ago in a galaxy far, far away..."];

        appState = [[AppState alloc] initWithTokenProvider:provider];
    });
    
    it(@"should return token from token provider", ^{
        [[appState.currentUserToken should] equal:@"A long time ago in a galaxy far, far away..."];
    });
});

SPEC_END