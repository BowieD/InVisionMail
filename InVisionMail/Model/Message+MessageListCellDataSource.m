//
//  Message+MessageListCellDataSource.m
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "Message+MessageListCellDataSource.h"

@implementation Message (MessageListCellDataSource)

- (NSString*) name {
    return @"Name unknown";
}

- (NSString*) subject {
    return @"Subject unknown";
}

- (NSString*) timestampString {
    return [NSString stringWithFormat:@"%.0f", self.timestamp];
}

@end
