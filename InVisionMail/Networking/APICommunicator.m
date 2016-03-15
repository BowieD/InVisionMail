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
    return [self authorizedGETRequest:MY_MESSAGES
                           parameters:@{LABELS_KEY: INBOX_LABEL_VALUE}
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  
        if (NO == [responseObject isKindOfClass:[NSDictionary class]]) {
            // TODO: error log
            return;
        }
        NSDictionary* responseDictionary = (NSDictionary*)responseObject;
        NSArray* messagesArray = (NSArray*)[responseDictionary objectForKey:@"messages"];
        
        for (NSDictionary* message in messagesArray) {
            NSString* messageID = [message objectForKey:@"id"];
            // Let's check if message this ID exist in the context.
            // If not, we should get metadata for it
            if ([Message withCustomId:messageID fromContext:context] == nil) {
                NSLog(@"Getting meta data for message: %@", messageID);
                [self getMessageMetadata:messageID toContext:context];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(error);
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
                NSLog(@"New message saved to the context: %@", element.description);
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(error);
    }];
}


@end
