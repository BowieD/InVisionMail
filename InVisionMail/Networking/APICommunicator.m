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
- (nullable NSURLSessionDataTask*) getMyMessages {
    return [self authorizedGETRequest:MY_MESSAGES parameters:@{LABELS_KEY: INBOX_LABEL_VALUE} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* d = (NSDictionary*)responseObject;
        NSLog(d.description);
        
        NSArray* ma = (NSArray*)[d objectForKey:@"messages"];
        
        for (NSDictionary* message in ma) {
            NSString* messageID = [message objectForKey:@"id"];
            [self getMessageMetadata:messageID];
        }
        
        NSLog(d.description);
//        [self getMessageMetadata:@"153568797e6f2bb2"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(error);
    }];
}

- (nullable NSURLSessionDataTask*) getMessageMetadata:(NSString *)messageId {
    return [self getMessageDetail:messageId withParameters:@{FORMAT_KEY: METADATA_VALUE}];
}

- (nullable NSURLSessionDataTask*) getMessageDetail:(NSString *)messageId {
    return [self getMessageDetail:messageId withParameters:nil];
}

- (nullable NSURLSessionDataTask*) getMessageDetail:(NSString *)messageId withParameters: (NSDictionary*)parameters {
    return [self authorizedGETRequest:[MY_MESSAGES stringByAppendingString:messageId] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSObject* d = (NSObject*)responseObject;
//        NSLog(d.description);
        
        if ([d isKindOfClass:[NSDictionary class]]) {
            NSDictionary* jsonData = (NSDictionary*)d;
            
            [Message loadFromJSON:jsonData customId:[jsonData valueForKey:@"id"] context:[CoreDataStack sharedInstance].syncContext completionBlock:^(NSManagedObject * _Nullable element) {
                NSLog(element.description);
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(error);
    }];
}


@end
