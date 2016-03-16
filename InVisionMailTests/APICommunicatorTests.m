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
#import "TestCoreDataStack.h"
#import "Message.h"
#import "NSManagedObject+Helpers.h"

SPEC_BEGIN(APICommunicatorTests)

describe(@"API Communicator", ^{
    __block NSObject<AccessTokenProvider>* tokenProvider;
    __block NSObject<NetworkCommunicator>* networkCommunicator;
    __block APICommunicator* communicator;
    __block TestCoreDataStack* coreDataStack;
    
    beforeEach(^{
        tokenProvider = [KWMock mockForProtocol:@protocol(AccessTokenProvider)];
        [tokenProvider stub:@selector(accessToken) andReturn:@"May the Force be with you"];
        
        networkCommunicator = [KWMock mockForProtocol:@protocol(NetworkCommunicator)];
        communicator = [[APICommunicator alloc] initWithNetworkCommunicator:networkCommunicator accessTokenProvider:tokenProvider];
        
        coreDataStack = [TestCoreDataStack new];
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
            
            [communicator getMyMessagesToContext:coreDataStack.mainContext];
        });
        
        it(@"should have labelIds:INBOX in parameters", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSDictionary* callParams = (NSDictionary*) params[1];
                NSString* formatParameterValue = (NSString *)[callParams valueForKey:@"labelIds"];
                
                [[formatParameterValue should] equal:@"INBOX"];
                
                return nil; // needed because of compiler
            }];
            
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMyMessagesToContext:coreDataStack.mainContext];
        });
        
        it(@"shoud call me/messages/ endpoint", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSString* path = (NSString *)params[0];
                [[path should] equal:@"me/messages/"];
                return nil; // needed because of compiler
            }];
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMyMessagesToContext:coreDataStack.mainContext];
        });
        
        it(@"should call getMessageMetada for messages without HistoryId", ^{
            // Simulate existing message
            Message* message = [Message findOrCreateElementWithId:@"HanAndLeia" context:coreDataStack.mainContext];
            message.historyId = @"EPISODE_IV_VII";
            
            // Prepare fake response
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                void (^success)(NSURLSessionDataTask*, id) = params[3];
                // We simulate server response for getMyMessages with the array of 2 messages
                success(nil, @{ @"messages": @[ @{@"id": @"LukeAndLeia"}, @{@"id": @"HanAndLeia"} ] });
                return nil; // needed because of compiler
            }];

            __block NSString* newMessageId = nil;
            [communicator stub:@selector(getMessageMetadata:toContext:) withBlock:^id(NSArray *params) {
                newMessageId = (NSString *)params[0];
                return nil; // just to make compiler happy
            }];
            
            [communicator getMyMessagesToContext:coreDataStack.mainContext];
            
            [[expectFutureValue(newMessageId) shouldEventually] equal:@"LukeAndLeia"];
            [[expectFutureValue(newMessageId) shouldNotEventually] equal:@"HanAndLeia"];
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
            
            [communicator getMessageDetail: @"EpisodeIV" toContext:coreDataStack.mainContext];
        });
        
        it(@"shoud call me/messages/episodeIV endpoint", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSString* path = (NSString *)params[0];
                [[path should] equal:@"me/messages/EpisodeIV"];
                return nil; // needed because of compiler
            }];
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMessageDetail: @"EpisodeIV" toContext:coreDataStack.mainContext];
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
            
            [communicator getMessageMetadata: @"EpisodeIV" toContext:coreDataStack.mainContext];
        });

        it(@"should have format:metadata in parameters", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSDictionary* callParams = (NSDictionary*) params[1];
                NSString* formatParameterValue = (NSString *)[callParams valueForKey:@"format"];
                
                [[formatParameterValue should] equal:@"metadata"];
                
                return nil; // needed because of compiler
            }];
            
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMessageMetadata: @"EpisodeIV" toContext:coreDataStack.mainContext];
        });
        
        it(@"shoud call me/messages/episodeIV endpoint", ^{
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                NSString* path = (NSString *)params[0];
                [[path should] equal:@"me/messages/EpisodeIV"];
                return nil; // needed because of compiler
            }];
            [[networkCommunicator should] receive:@selector(GET:parameters:progress:success:failure:)];
            
            [communicator getMessageMetadata: @"EpisodeIV" toContext:coreDataStack.mainContext];
        });
        
        it(@"should add the received message to the context", ^{
            // Prepare fake response
            [networkCommunicator stub:@selector(GET:parameters:progress:success:failure:) withBlock:^id(NSArray *params) {
                void (^success)(NSURLSessionDataTask*, id) = params[3];
                NSDictionary* dummyData = @{
                                            @"id": @"BobaFett",
                                            @"internalDate": @"1234",
                                            @"threadId": @"EpisodeIV",
                                            @"historyId": @"1997",
                                            @"snippet": @"When 900 years old, you reach… Look as good, you will not."
                                            };
                // We simulate server response with message with id "BobaFett"
                success(nil, dummyData);
                return nil; // needed because of compiler
            }];

            [communicator getMessageMetadata:@"BobaFett" toContext:coreDataStack.mainContext];
            
            [[expectFutureValue(theValue([Message withCustomId:@"BobaFett" fromContext:coreDataStack.mainContext].timestamp))
              shouldEventually] equal:theValue(1234)];
            
            [[expectFutureValue([Message withCustomId:@"BobaFett" fromContext:coreDataStack.mainContext].threadId)
              shouldEventually] equal:@"EpisodeIV"];
            
            [[expectFutureValue([Message withCustomId:@"BobaFett" fromContext:coreDataStack.mainContext].historyId)
              shouldEventually] equal:@"1997"];
            
            [[expectFutureValue([Message withCustomId:@"BobaFett" fromContext:coreDataStack.mainContext].snippet)
              shouldEventually] equal:@"When 900 years old, you reach… Look as good, you will not."];
        });
    });


});

SPEC_END