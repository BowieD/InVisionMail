//
//  MessageListCell.h
//  InVisionMail
//
//  Created by Vojta Stavik on 16/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageListCellDataSource <NSObject>

- (NSString*) name;
- (NSString*) subject;
- (NSString*) snippet;
- (NSString*) timestampString;
- (BOOL) unread;

@end

@interface MessageListCell : UITableViewCell

- (void) loadData: (id<MessageListCellDataSource>) dataSource;

@end
