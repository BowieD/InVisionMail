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

@end

@interface MessageListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *snippetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentIcon;
@property (weak, nonatomic) IBOutlet UIView *unreadMark;

- (void) loadData: (id<MessageListCellDataSource>) dataSource;

@end
