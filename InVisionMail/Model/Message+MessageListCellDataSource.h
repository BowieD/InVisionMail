//
//  Message+MessageListCellDataSource.h
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "Message.h"
#import "MessageListCell.h"

@interface Message (MessageListCellDataSource) <MessageListCellDataSource>

- (NSString*) name;
- (NSString*) timestampString;
- (NSString*) timestampStringWithTodaysDate: (NSDate*)date;

@end
