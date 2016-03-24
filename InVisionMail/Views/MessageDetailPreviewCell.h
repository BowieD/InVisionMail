//
//  MessageDetailPreviewCell.h
//  InVisionMail
//
//  Created by Vojta Stavik on 24/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageDetailPreviewCellDataSource <NSObject>
- (NSString*) name;
- (NSString*) snippet;
- (NSString*) timestampString;
- (UIImage*)  avatarImage;
@end

@interface MessageDetailPreviewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextView *nameTextView;
@property (nonatomic, weak) IBOutlet UITextView *snippetTextView;
@property (nonatomic, weak) IBOutlet UILabel *timestampLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

- (void) loadData: (id<MessageDetailPreviewCellDataSource>) dataSource;

@end
