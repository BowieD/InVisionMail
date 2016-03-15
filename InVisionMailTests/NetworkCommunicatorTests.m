//
//  NetworkCommunicatorTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 14/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "NetworkCommunicator.h"

SPEC_BEGIN(NetworkCommunicatorTests)

describe(@"Gmail network communicator", ^{
    __block GmailCommunicator* communicator;
    
    beforeEach(^{
        communicator = [GmailCommunicator new];
    });
    
    it(@"should invoke get request when GET is called ", ^{
        [[communicator.manager should] receive:@selector(GET: parameters: progress: success: failure:)];
        [communicator GET:@"Death Star" parameters:nil progress:nil success:nil failure:nil];
    });
    
    it(@"should use JSON response serializer", ^{
        [[communicator.manager.responseSerializer should] beKindOfClass:[AFJSONResponseSerializer class]];
    });
 });

SPEC_END