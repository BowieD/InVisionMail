//
//  APICommunicator.h
//  InVisionMail
//
//  Created by Vojta Stavik on 12/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkCommunicator.h"
#import <AFNetworking/AFNetworking.h>
#import "AccessTokenProvider.h"

@interface APICommunicator : NSObject

+ (nonnull instancetype) sharedCommunicator;
- (nonnull instancetype) initWithNetworkCommunicator: (NSObject<NetworkCommunicator> * _Nonnull) networkCommunicator
                                 accessTokenProvider: (NSObject<AccessTokenProvider> * _Nonnull) accessTokenProvider;

@property (nonatomic, strong, readonly) NSObject<NetworkCommunicator>* _Nonnull networkCommunicator;
@property (nonatomic, strong, readonly) NSObject<AccessTokenProvider>* _Nonnull accessTokenProvider;

- (nullable NSURLSessionDataTask*) authorizedGETRequest: (NSString* _Nonnull)path
                                    parameters: (NSDictionary* _Nullable)parameters
                                       success: (nullable void (^)(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject))success
                                       failure: (nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError* _Nonnull error))failure;


#pragma mark - Gmail requests

/**
 Get list of all user's messages. It currently returns only 100 newest messages.
 */
- (nullable NSURLSessionDataTask*) getMyMessages;

/**
 Get metadata for the message. This call doesn't download message's body.
 */
- (nullable NSURLSessionDataTask*) getMessageMetadata: (NSString * _Nonnull) messageId;

/**
 Get all data for the message including the message body.
 */
- (nullable NSURLSessionDataTask*) getMessageDetail: (NSString * _Nonnull) messageId;

@end
