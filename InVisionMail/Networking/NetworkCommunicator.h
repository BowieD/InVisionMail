//
//  NetworkCommunicator.h
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFnetworking.h>

@protocol NetworkCommunicator <NSObject>
- (nullable NSURLSessionDataTask*)GET:(NSString * _Nonnull)URLString
                           parameters:(nullable id)parameters
                             progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress)) downloadProgress
                              success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                              failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

@end


@interface GmailCommunicator: NSObject <NetworkCommunicator>

@property (nonatomic, strong, readonly) AFHTTPSessionManager* _Nonnull manager;

- (nullable NSURLSessionDataTask*)GET:(NSString * _Nonnull)URLString
                           parameters:(nullable id)parameters
                             progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress)) downloadProgress
                              success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                              failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
@end