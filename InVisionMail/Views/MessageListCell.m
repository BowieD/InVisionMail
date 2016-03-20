//
//  MessageListCell.m
//  InVisionMail
//
//  Created by Vojta Stavik on 16/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

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
}

@end
