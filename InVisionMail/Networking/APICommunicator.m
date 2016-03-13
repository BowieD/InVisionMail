//
//  IVMAPICommunicator.m
//  InVisionMail
//
//  Created by Vojta Stavik on 12/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "APICommunicator.h"

@implementation APICommunicator

+ (NSURLSessionDataTask *) test: (NSString *) token {
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    return [manager GET:@"https://www.googleapis.com/gmail/v1/users/me/threads" parameters:@{@"access_token": token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}


@end
