//
//  APICommunicator.h
//  InVisionMail
//
//  Created by Vojta Stavik on 12/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface APICommunicator : NSObject

+ (NSURLSessionDataTask *) test: (NSString *) token;

@end
