//
//  MessageListCell.m
//  InVisionMail
//
//  Created by Vojta Stavik on 16/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageListCell.h"
#import "UIFont+AppFonts.h"

@implementation MessageListCell

- (UIFont*) nameLabelFont {
    return [UIFont preferredFontForTextStyle:@"Headline"];
}

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

- (void) applyUnreadAppearance: (BOOL) unread {
    if (unread) {
        self.nameLabel.font = [UIFont mainTitleFont_Bold];
        self.subjectLabel.font = [UIFont regularTextFont_Bold];
    } else {
        self.nameLabel.font = [UIFont mainTitleFont_Regular];
        self.subjectLabel.font = [UIFont regularTextFont_Regular];
    }
    
    self.snippetLabel.font = [UIFont regularTextFont_Regular];
}

@end
