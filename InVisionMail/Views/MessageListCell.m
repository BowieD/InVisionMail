//
//  MessageListCell.m
//  InVisionMail
//
//  Created by Vojta Stavik on 16/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageListCell.h"
#import "UIFont+AppFonts.h"
#import "UIColor+AppColors.h"

@interface MessageListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *snippetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentIcon;
@property (weak, nonatomic) IBOutlet UIView *unreadMark;
@end


@implementation MessageListCell

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self setupAppearance];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupAppearance {
    self.unreadMark.backgroundColor = [UIColor invision_greenColor];
    
    self.nameLabel.textColor = [UIColor invision_textColor];
    self.subjectLabel.textColor = [UIColor invision_textColor];
    self.snippetLabel.textColor = [UIColor invision_textColor];
    self.snippetLabel.font = [UIFont regularTextFont_Regular];
    
    self.attachmentIcon.hidden = YES;
}

- (void) applyUnreadAppearance: (BOOL) unread {
    if (unread) {
        self.nameLabel.font = [UIFont mainTitleFont_Bold];
        self.subjectLabel.font = [UIFont regularTextFont_Bold];
    } else {
        self.nameLabel.font = [UIFont mainTitleFont_Regular];
        self.subjectLabel.font = [UIFont regularTextFont_Regular];
    }
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Data

- (void) prepareForReuse {
    [super prepareForReuse];
    
    self.nameLabel.text     = nil;
    self.subjectLabel.text  = nil;
    self.timestampLabel.text = nil;
    self.unreadMark.hidden  = YES;
    self.attachmentIcon.hidden = YES;
}

- (void) loadData: (id<MessageListCellDataSource>) dataSource {
    self.nameLabel.text = dataSource.name;
    self.subjectLabel.text = dataSource.subject;
    self.timestampLabel.text = dataSource.timestampString;
    self.snippetLabel.text = dataSource.snippet;
    self.unreadMark.hidden = NO == dataSource.unread;
    
    [self applyUnreadAppearance:dataSource.unread];
}


@end
