//
//  NetworkCommunicator.m
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "NetworkCommunicator.h"
#import "GmailAPISpecification.h"

@interface GmailCommunicator ()
@property (nonatomic, strong, readwrite) AFHTTPSessionManager* manager;
@end

@implementation GmailCommunicator

- (instancetype) init {
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GMAIL_BASE_ADDRESS]];
    }
    return self;
}

- (nullable NSURLSessionDataTask*)GET:(NSString * _Nonnull)URLString
                           parameters:(nullable id)parameters
                             progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress)) downloadProgress
                              success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                              failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {

    return [self.manager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

@end
