//
//  MessageDetailPreviewCell.m
//  InVisionMail
//
//  Created by Vojta Stavik on 24/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageDetailPreviewCell.h"

@implementation MessageDetailPreviewCell

- (void) prepareForReuse {
    [super prepareForReuse];
    
    self.nameTextView.text = @"";
    self.snippetTextView.text = @"";
    self.timestampLabel.text = @"";
    self.avatarImageView.image = nil;
}

- (void) loadData:(id<MessageDetailPreviewCellDataSource>)dataSource {
    self.nameTextView.text = [dataSource name];
    self.snippetTextView.text = [dataSource snippet];
    self.timestampLabel.text = [dataSource timestampString];

    // In the real project, the following line should propably
    // just set URL of the image to ImageView. We would use
    // something like SDWebImage, AFImageView, etc..
    self.avatarImageView.image = [dataSource avatarImage];
}

@end
