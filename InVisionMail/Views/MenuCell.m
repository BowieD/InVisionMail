//
//  MenuCell.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MenuCell.h"
#import "UIFont+AppFonts.h"
#import "UIColor+AppColors.h"

@interface MenuCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end


@implementation MenuCell

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) awakeFromNib {
    [super awakeFromNib];
    [self setupAppearance];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupAppearance {
    self.backgroundColor = [UIColor clearColor];
    
    self.iconImageView.tintColor = [UIColor invision_drawerTextColor];
    
    self.titleLabel.textColor = [UIColor invision_drawerTextColor];
    self.titleLabel.font = [UIFont mainTitleFont_Bold];
}

- (void) changeToSelectedAppearance {
    self.backgroundColor = [UIColor invision_drawerSelectedColor];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.iconImageView.tintColor = [UIColor whiteColor];
}

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Data

- (void) prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = nil;
}

- (void) loadData: (id<MenuCellDataSource>) dataSource {
    self.titleLabel.text = dataSource.formattedTitle;
}

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Selection

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self changeToSelectedAppearance];
    } else {
        [self setupAppearance];
    }
}



@end
