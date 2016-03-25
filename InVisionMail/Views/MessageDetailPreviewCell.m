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

@property (nonatomic, strong) NSArray* tempConstraints;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end



@implementation MessageDetailPreviewCell

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self.snippetTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.nameTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self updateConstraintsForNonSelectedState];
    self.replyButton.alpha = 0;
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
    if (selected == self.isSelected) {
        // state not changed, do nothing
        return;
    }
    
    [super setSelected:selected animated:animated];
    
    [UIView animateWithDuration:0.33 animations:^{
        if (selected) {
            self.textLeadingConstraint.constant = 16;
            self.replyButton.alpha = 1;
            [self updateConstraintsForSelectedState];
        } else {
            self.textLeadingConstraint.constant = 38 + 16 + 8;
            self.replyButton.alpha = 0;
            [self updateConstraintsForNonSelectedState];
        }
        
        [self layoutIfNeeded];
    }];
}

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Layout

- (void) updateConstraintsForSelectedState {
    [self.contentView removeConstraints:self.tempConstraints];
    
    NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:_timestampLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_nameTextView attribute:NSLayoutAttributeLeading multiplier:1 constant:5];
    
    NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:_timestampLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_nameTextView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    self.tempConstraints = @[c1, c2];
    
    [self.contentView addConstraints:self.tempConstraints];
}

- (void) updateConstraintsForNonSelectedState {
    [self.contentView removeConstraints:self.tempConstraints];
    
    NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:_timestampLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:8];
    
    NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:_timestampLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-16];
    
    self.tempConstraints = @[c1, c2];
    
    [self.contentView addConstraints:self.tempConstraints];
}



// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Desired heights

+ (CGFloat) previewHeight {
    return 65;
}

+ (CGFloat) desiredHeightForWidth: (CGFloat)width andData: (id<MessageDetailPreviewCellDataSource>)dataSource {
    
    // We want to use mock cell to get all the interface builder changes
    static MessageDetailPreviewCell* cell = nil;
    
    if (cell == nil) {
        cell = (MessageDetailPreviewCell*)[[[NSBundle mainBundle] loadNibNamed:@"MessageDetailPreviewCell" owner:self options:nil] firstObject];
    }
    
    UIFont *usedFont = cell.snippetTextView.font;
    NSDictionary *attributes = @{NSFontAttributeName : usedFont};
    
    NSString* text = [dataSource body];
    
    if (text == nil) {
        text = @"";
    }
    
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    cell.snippetTextView.attributedText = attrString;
    
    width -= 2*16; // horizonal borders
    
    CGFloat bodyHeight = [cell.snippetTextView sizeThatFits: CGSizeMake(width, CGFLOAT_MAX)].height;
    
    CGFloat headerHeight = [MessageDetailPreviewCell previewHeight];
    CGFloat borders = 2 * 8; // vertical borders
    
    return bodyHeight + headerHeight + borders;
}


@end
