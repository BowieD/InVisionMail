//
//  MessageDetailPreviewCell.h
//  InVisionMail
//
//  Created by Vojta Stavik on 24/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message+MessageListCellDataSource.h"

@protocol MessageDetailPreviewCellDataSource <MessageListCellDataSource>
- (UIImage*)  avatarImage;
- (NSString*) body;
@end

@interface MessageDetailPreviewCell : UITableViewCell

- (void) loadData: (id<MessageDetailPreviewCellDataSource>) dataSource;

/**
 Height of the cell in non-selected state (message preview)
 */
+ (CGFloat) previewHeight;

/**
 Height of the cell in selected state (full message view)
 */
+ (CGFloat) desiredHeightForWidth: (CGFloat)width andData: (id<MessageDetailPreviewCellDataSource>) dataSource;

@end
