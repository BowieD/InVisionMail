//
//  MessageDetailPreviewCell.m
//  InVisionMail
//
//  Created by Vojta Stavik on 24/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageDetailPreviewCell.h"
#import "UITableViewCell+Helpers.h"
#import "UIFont+AppFonts.h"

@interface MessageDetailPreviewCell ()

@property (nonatomic, weak) IBOutlet UITextView *nameTextView;
@property (nonatomic, weak) IBOutlet UITextView *snippetTextView;
@property (nonatomic, weak) IBOutlet UILabel *timestampLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLeadingConstraint;
@property (nonatomic, strong) NSArray* tempConstraints;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, getter=isBodyLoaded) BOOL bodyLoaded;

@end



@implementation MessageDetailPreviewCell
// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Preferences

static CGFloat messagePreviewHeight = 70;



// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self setupAppearance];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupAppearance {
    self.snippetTextView.font = [UIFont regularTextFont_Regular];
    self.nameTextView.font = [UIFont regularTextFont_Bold];
    
    [self.snippetTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.nameTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.activityIndicator stopAnimating];
    
    [self updateAppearanceForNonSelectedState];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Data

- (void) prepareForReuse {
    [super prepareForReuse];
    
    self.nameTextView.text = @"";
    self.snippetTextView.text = @"";
    self.timestampLabel.text = @"";
    self.avatarImageView.image = nil;
    
    [self.activityIndicator stopAnimating];
    
    self.selectedBackgroundView = nil;
}

- (void) loadData:(id<MessageDetailPreviewCellDataSource>)dataSource {
    
    self.bodyLoaded = [dataSource body] != nil;
    
    if ([self isBodyLoaded]) {
        [self.activityIndicator stopAnimating];
    }
    
    if ([self isSelected]) {
        self.snippetTextView.text = [dataSource body];
    } else {
        // If we don't have body yet, we will use snippet
        self.snippetTextView.text = [dataSource body] == nil ? [dataSource snippet] : [dataSource body];
    }
    
    self.nameTextView.text = [dataSource name];
    self.timestampLabel.text = [dataSource timestampString];

    // In the real project, the following line should propably
    // just set URL of the image to ImageView. We would use
    // something like SDWebImage or AF category for ImageView, etc..
    self.avatarImageView.image = [dataSource avatarImage];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Selected

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (selected && [self isBodyLoaded] == NO) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
    if (selected == self.isSelected) {
        // state not changed, do nothing
        return;
    }
    
    [super setSelected:selected animated:animated];
    
    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (selected) {
            self.textLeadingConstraint.constant = 16;
            [self updateAppearanceForSelectedState];
        } else {
            CGFloat edges = 16 + 8 + 4;
            self.textLeadingConstraint.constant = 38 + edges;
            [self updateAppearanceForNonSelectedState];
        }
        
        [self layoutIfNeeded];
    } completion:nil];
}

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Layout

- (void) updateAppearanceForSelectedState {
    [self.contentView removeConstraints:self.tempConstraints];
    
    // Add constraints to have timestamp label below name view
    NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:_timestampLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_nameTextView attribute:NSLayoutAttributeLeading multiplier:1 constant:5];
    
    NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:_timestampLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_nameTextView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    self.tempConstraints = @[c1, c2];
    
    [self.contentView addConstraints:self.tempConstraints];
    
    self.replyButton.alpha = 1;
    self.snippetTextView.alpha = 1;
    
    // Allow user interaction (text selecting) when cell is selected.
    self.snippetTextView.userInteractionEnabled = YES;
    self.nameTextView.userInteractionEnabled = YES;
}

- (void) updateAppearanceForNonSelectedState {
    [self.contentView removeConstraints:self.tempConstraints];
    
    // Add constraints to have timestamp on the right top corner of the cell
    NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:_timestampLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:8];
    
    NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:_timestampLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-16];
    
    self.tempConstraints = @[c1, c2];
    
    [self.contentView addConstraints:self.tempConstraints];
    
    self.replyButton.alpha = 0;
    self.snippetTextView.alpha = 0.5;
    
    // Disable user interaction when cell is not selected. This will make selectable textViews
    // transparent for touches and allow user to tap everywhere on the cell to select it.
    self.snippetTextView.userInteractionEnabled = NO;
    self.nameTextView.userInteractionEnabled = NO;
}



// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Desired heights

+ (CGFloat) previewHeight {
    return messagePreviewHeight;
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
    
    width -= 2 * 16; // horizonal borders
    
    CGFloat bodyHeight = [cell.snippetTextView sizeThatFits: CGSizeMake(width, CGFLOAT_MAX)].height;
    
    CGFloat headerHeight = [MessageDetailPreviewCell previewHeight];
    CGFloat borders = 1 * 8; // vertical borders
    
    return bodyHeight + headerHeight + borders;
}


@end
