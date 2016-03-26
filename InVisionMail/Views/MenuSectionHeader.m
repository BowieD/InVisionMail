//
//  MenuSectionHeader.m
//  InVisionMail
//
//  Created by Vojta Stavik on 26/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MenuSectionHeader.h"
#import "UIFont+AppFonts.h"
#import "UIColor+AppColors.h"

@interface MenuSectionHeader ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation MenuSectionHeader

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) awakeFromNib {
    [super awakeFromNib];
    [self setupAppearance];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupAppearance {
    self.titleLabel.font = [UIFont regularTextFont_Regular];
    self.titleLabel.textColor = [[UIColor invision_drawerTextColor] colorWithAlphaComponent:0.7];
    
    UIView* background = [UIView new];
    background.backgroundColor = [UIColor invision_drawerHeaderColor];
    self.backgroundView = background;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Data

- (void) setTitle:(NSString *)title {
    self.titleLabel.text = [title uppercaseString];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Helpers

+ (NSString*) reuseIdentifier {
    return NSStringFromClass(self);
}

+ (nullable UINib*) nib {
    return [UINib nibWithNibName:[self reuseIdentifier] bundle:[NSBundle bundleForClass:self]];
}




@end
