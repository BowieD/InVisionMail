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
        [tokenProvider stub:@selector(accessToken) andReturn:@"May the Force be with you"];
        
        networkCommunicator = [KWMock mockForProtocol:@protocol(NetworkCommunicator)];
        communicator = [[APICommunicator alloc] initWithNetworkCommunicator:networkCommunicator accessTokenProvider:tokenProvider];
    });
    
    it(@"should add access_token parameter to authorized GET requests", ^{
        [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
            NSDictionary* callParams = (NSDictionary*) params[1];
            NSString* accessTokenValue = (NSString *)[callParams valueForKey:@"access_token"];

            [[accessTokenValue should] equal:@"May the Force be with you"];
            
            return nil; // needed because of compiler
        }];
        
        [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
        
        [communicator authorizedGETRequest:@"/episodeVII" parameters:nil success:nil failure:nil];
    });
    
    
    // ------------  ------------  ------------  ------------  ------------  ------------
    // Calls 
    
    describe(@"Get my messages call", ^{
        it(@"should be authorized", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSDictionary* callParams = (NSDictionary*) params[1];
                NSString* accessTokenValue = (NSString *)[callParams valueForKey:@"access_token"];
                
                [[accessTokenValue should] equal:@"May the Force be with you"];
                
                return nil; // needed because of compiler
            }];
            
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMyMessages];
        });
        
        it(@"should have labelIds:INBOX in parameters", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSDictionary* callParams = (NSDictionary*) params[1];
                NSString* formatParameterValue = (NSString *)[callParams valueForKey:@"labelIds"];
                
                [[formatParameterValue should] equal:@"INBOX"];
                
                return nil; // needed because of compiler
            }];
            
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMyMessages];
        });
        
        it(@"shoud call me/messages/ endpoint", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSString* path = (NSString *)params[0];
                [[path should] equal:@"me/messages/"];
                return nil; // needed because of compiler
            }];
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMyMessages];
        });
    });

    describe(@"Get message detail call", ^{
        it(@"should be authorized", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSDictionary* callParams = (NSDictionary*) params[1];
                NSString* accessTokenValue = (NSString *)[callParams valueForKey:@"access_token"];
                
                [[accessTokenValue should] equal:@"May the Force be with you"];
                
                return nil; // needed because of compiler
            }];
            
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMessageDetail: @"EpisodeIV"];
        });
        
        it(@"shoud call me/messages/episodeIV endpoint", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSString* path = (NSString *)params[0];
                [[path should] equal:@"me/messages/EpisodeIV"];
                return nil; // needed because of compiler
            }];
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMessageDetail: @"EpisodeIV"];
        });
    });
    
    describe(@"Get message metadata call", ^{
        it(@"should be authorized", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSDictionary* callParams = (NSDictionary*) params[1];
                NSString* accessTokenValue = (NSString *)[callParams valueForKey:@"access_token"];
                
                [[accessTokenValue should] equal:@"May the Force be with you"];
                
                return nil; // needed because of compiler
            }];
            
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMessageMetadata: @"EpisodeIV"];
        });

        it(@"should have format:metadata in parameters", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSDictionary* callParams = (NSDictionary*) params[1];
                NSString* formatParameterValue = (NSString *)[callParams valueForKey:@"format"];
                
                [[formatParameterValue should] equal:@"metadata"];
                
                return nil; // needed because of compiler
            }];
            
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMessageMetadata: @"EpisodeIV"];
        });
        
        it(@"shoud call me/messages/episodeIV endpoint", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSString* path = (NSString *)params[0];
                [[path should] equal:@"me/messages/EpisodeIV"];
                return nil; // needed because of compiler
            }];
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMessageMetadata: @"EpisodeIV"];
        });
    });


});

SPEC_END