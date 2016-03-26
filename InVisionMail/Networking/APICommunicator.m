//
//  APICommunicator.m
//  InVisionMail
//
//  Created by Vojta Stavik on 12/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "APICommunicator.h"
#import "AppState.h"
#import "GmailAPISpecification.h"
#import "Message.h"
#import "NSManagedObject+Helpers.h"
#import "CoreDataStack.h"
#import "Label.h"

@interface APICommunicator ()
@property (nonatomic, strong, readwrite) NSObject<NetworkCommunicator>* _Nonnull networkCommunicator;
@property (nonatomic, strong, readwrite) NSObject<AccessTokenProvider>* _Nonnull accessTokenProvider;
@end

@implementation APICommunicator

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Initializers

+ (instancetype) sharedCommunicator {
    static APICommunicator* sharedCommunicator = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedCommunicator = [[self alloc] initWithNetworkCommunicator:[GmailCommunicator new]
                                                   accessTokenProvider:[AppState sharedState].tokenProvider];
    });
    
    return sharedCommunicator;
}

- (nonnull instancetype) initWithNetworkCommunicator: (NSObject<NetworkCommunicator> * _Nonnull) networkCommunicator
                                 accessTokenProvider: (NSObject<AccessTokenProvider> * _Nonnull) accessTokenProvider {
    if (self = [super init]) {
        self.networkCommunicator = networkCommunicator;
        self.accessTokenProvider = accessTokenProvider;
    }
    return self;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Authorized request factory

// Create and invoke GET request with the current user access token
- (NSURLSessionDataTask*) authorizedGETRequest: (NSString*)path
                                    parameters: (NSDictionary*)parameters
                                       success: (nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                       failure: (nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {

    NSMutableDictionary* mutableParameters = [parameters mutableCopy];
    if (mutableParameters == nil) {
        // Input parameters dictionary is nill
        mutableParameters = [NSMutableDictionary new];
    }
    mutableParameters[ACCESS_TOKEN_KEY] = self.accessTokenProvider.accessToken;
    
    return [self.networkCommunicator GET:path parameters:[mutableParameters copy] progress:nil success:success failure:failure];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Gmail calls
- (nullable NSURLSessionDataTask*) getMyMessagesToContext: (NSManagedObjectContext* _Nonnull)context {
    return [self getMyMessagesToContext:context completion:nil];
}

- (nullable NSURLSessionDataTask*) getMyMessagesToContext: (NSManagedObjectContext* _Nonnull)context completion: (nullable void (^)(NSError* _Nullable error))completion {
    
    return [self authorizedGETRequest:MY_MESSAGES
                           parameters:@{LABELS_IDS_KEY: INBOX_LABEL_VALUE}
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  
        if (NO == [responseObject isKindOfClass:[NSDictionary class]]) {
            // TODO: error log
            return;
        }
                                  
        NSDictionary* responseDictionary = (NSDictionary*)responseObject;
        NSArray* messagesArray = (NSArray*)[responseDictionary objectForKey:MESSAGES_KEY];
        
        for (NSDictionary* message in messagesArray) {
            NSString* messageID = [message objectForKey:ID_KEY];
            
            // Let's check if message with this ID exist in the context and
            // if we have metadata downloaded
            Message* m = [Message withCustomId:messageID fromContext:context];
            BOOL messageNotExists = m == nil;
            BOOL messageWithoutMetadata = m.historyId == nil && m.snippet == nil && m.timestamp == 0;
            
            if (messageNotExists || messageWithoutMetadata) {
                // Prepare message object in the context.
                // We use these empty objects to indicate
                // pending data loading in the InboxVC.
                // Nothing will change, if the message already
                // exists in the context.
                [Message loadFromJSON:nil customId:messageID context:context completionBlock:nil];

//                NSLog(@"Getting meta data for message: %@", messageID);
                [self getMessageMetadata:messageID toContext:context];
            }
            
            if (completion) {
                completion(nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (nullable NSURLSessionDataTask*) getMessageMetadata:(NSString *)messageId toContext: (NSManagedObjectContext* _Nonnull)context {
    return [self getMessageDetail:messageId withParameters:@{FORMAT_KEY: METADATA_VALUE} toContext:context];
}

- (nullable NSURLSessionDataTask*) getMessageDetail:(NSString *)messageId toContext: (NSManagedObjectContext* _Nonnull)context {
    return [self getMessageDetail:messageId withParameters:nil toContext:context];
}

- (nullable NSURLSessionDataTask*) getMessageDetail:(NSString *)messageId withParameters: (NSDictionary*)parameters toContext: (NSManagedObjectContext* _Nonnull)context {
    return [self authorizedGETRequest:[MY_MESSAGES stringByAppendingString:messageId] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* jsonData = (NSDictionary*)responseObject;
            [Message loadFromJSON:jsonData customId:[jsonData valueForKey:@"id"] context:context completionBlock:^(NSManagedObject * _Nullable element) {
//                NSLog(@"New message saved to the context: %@", element.description);
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(error.localizedDescription);
    }];
}

- (nullable NSURLSessionDataTask*) getMyLabelsToContext:(NSManagedObjectContext *)context {
    return [self authorizedGETRequest:MY_LABELS
                           parameters:nil
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (NO == [responseObject isKindOfClass:[NSDictionary class]]) {
            // TODO: error log
            return;
        }
        
        NSDictionary* responseDictionary = (NSDictionary*)responseObject;
        NSArray* labelsArray = (NSArray*)[responseDictionary objectForKey:LABELS_KEY];
                                  
        NSLog(@"%@", responseDictionary.debugDescription);
                                  
        for (NSDictionary* label in labelsArray) {
            NSString* labelId = [label objectForKey:ID_KEY];
            
            [Label loadFromJSON:label customId:labelId context:context completionBlock:^(NSManagedObject * _Nullable element) {
//                NSLog(@"Label added: %@", element.description);
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(error.localizedDescription);
    }];
}


@end
