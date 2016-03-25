//
//  MessageDetailPreviewCell.m
//  InVisionMail
//
//  Created by Vojta Stavik on 24/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageDetailPreviewCell.h"
#import "UITableViewCell+Helpers.h"

@interface MessageDetailPreviewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLeadingConstraint;

@end

@implementation MessageDetailPreviewCell

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self.snippetTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.nameTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void) prepareForReuse {
    [super prepareForReuse];
    
    self.nameTextView.text = @"";
    self.snippetTextView.text = @"";
    self.timestampLabel.text = @"";
    self.avatarImageView.image = nil;
    
    self.selectedBackgroundView = nil;
}


- (void) loadData:(id<MessageDetailPreviewCellDataSource>)dataSource {
    self.nameTextView.text = [dataSource name];
    
    if ([self isSelected]) {
        self.snippetTextView.text = [dataSource body];
    } else {
        // If we don't have body yet, we will use snippet
        self.snippetTextView.text = [dataSource body] == nil ? [dataSource snippet] : [dataSource body];
    }
    
    
    self.timestampLabel.text = [dataSource timestampString];

    // In the real project, the following line should propably
    // just set URL of the image to ImageView. We would use
    // something like SDWebImage or AF category for ImageView, etc..
    self.avatarImageView.image = [dataSource avatarImage];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [UIView animateWithDuration:0.33 animations:^{
        if (selected) {
            self.textLeadingConstraint.constant = 8;
        } else {
            self.textLeadingConstraint.constant = 30 + 2*8;
        }
        
        [self layoutIfNeeded];
    }];
}

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Desired heights

+ (CGFloat) previewHeight {
    return 55;
}

+ (CGFloat) desiredHeightForWidth: (CGFloat)width andData: (id<MessageDetailPreviewCellDataSource>)dataSource {
    
    // We want to use mock cell to get all the interface builder changes
    static MessageDetailPreviewCell* cell = nil;
    
    if (cell == nil) {
        cell = (MessageDetailPreviewCell*)[[[NSBundle mainBundle] loadNibNamed:@"MessageDetailPreviewCell" owner:self options:nil] firstObject];
    }
    
    UIFont *usedFont = cell.snippetTextView.font;
    NSDictionary *attributes = @{NSFontAttributeName : usedFont};
    
    NSString* text = [dataSource body] == nil ? [dataSource snippet] : [dataSource body];
    
    if (text == nil) {
        text = @"";
    }
    
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    cell.snippetTextView.attributedText = attrString;
    
    width -= 2*8; // horizonal borders
    
    CGFloat bodyHeight = [cell.snippetTextView sizeThatFits: CGSizeMake(width, CGFLOAT_MAX)].height;
    
    CGFloat headerHeight = [MessageDetailPreviewCell previewHeight];
    CGFloat borders = 2 * 8; // vertical borders
    
    return bodyHeight + headerHeight + borders;
}


@end
