//
//  APICommunicatorTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "APICommunicator.h"

SPEC_BEGIN(APICommunicatorTests)

describe(@"API Communicator", ^{
    __block NSObject<AccessTokenProvider>* tokenProvider;
    __block NSObject<NetworkCommunicator>* networkCommunicator;
    __block APICommunicator* communicator;

    beforeEach(^{
        tokenProvider = [KWMock mockForProtocol:@protocol(AccessTokenProvider)];
        networkCommunicator = [KWMock mockForProtocol:@protocol(NetworkCommunicator)];
        communicator = [[APICommunicator alloc] initWithNetworkCommunicator:networkCommunicator accessTokenProvider:tokenProvider];
    });
    
    it(@"should add access_token parameter to authorized GET requests", ^{
        [tokenProvider stub:@selector(accessToken) andReturn:@"May the Force be with you"];
        
        __block NSString* accessTokenValue = nil;
        [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
            NSDictionary* callParams = (NSDictionary*) params[1];
            accessTokenValue = (NSString *)[callParams valueForKey:@"access_token"];
            return nil; // needed because of compiler
        }];
        
        [communicator authorizedGETRequest:@"/episodeVII" parameters:nil success:nil failure:nil];
        [[accessTokenValue should] equal:@"May the Force be with you"];
    });
});

SPEC_END