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
#import <CoreData/CoreData.h>

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
 Get list of user's INBOX messages. It currently returns only 100 newest messages. If the message is new, getMessageMetadata for it is called automatically.
 */
- (nullable NSURLSessionDataTask*) getMyMessagesToContext: (NSManagedObjectContext* _Nonnull)context completion: (nullable void (^)(NSError* _Nullable error))completion;

- (nullable NSURLSessionDataTask*) getMyMessagesToContext: (NSManagedObjectContext* _Nonnull)context;


/**
 Get metadata for the message. This call doesn't download message's body. You usually don't call this function directly. It's called automatically for all new messages from the getMyMessagesIntoContext call.
 */
- (nullable NSURLSessionDataTask*) getMessageMetadata: (NSString * _Nonnull) messageId
                                            toContext: (NSManagedObjectContext* _Nonnull)context;

/**
 Get all data for the message including the message body.
 */
- (nullable NSURLSessionDataTask*) getMessageDetail: (NSString * _Nonnull) messageId
                                          toContext: (NSManagedObjectContext* _Nonnull)context;


/**
 Get list of available message LABELS.
 */
- (nullable NSURLSessionDataTask*) getMyLabelsToContext: (NSManagedObjectContext* _Nonnull)context;


@end
