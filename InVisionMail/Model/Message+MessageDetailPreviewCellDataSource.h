//
//  Message+MessageDetailPreviewCellDataSource.h
//  InVisionMail
//
//  Created by Vojta Stavik on 25/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "Message.h"
#import "MessageDetailPreviewCell.h"

@interface Message (MessageDetailPreviewCellDataSource) <MessageDetailPreviewCellDataSource>

- (UIImage*)  avatarImage;

@end
