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


//
//+ (NSURLSessionDataTask *) test: (NSString *) token {
//    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
//    
//    return [manager GET:@"https://www.googleapis.com/gmail/v1/users/me/threads" parameters:@{@"access_token": token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
//}
//

@end
