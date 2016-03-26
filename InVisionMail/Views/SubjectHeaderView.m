//
//  SubjectHeaderView.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "SubjectHeaderView.h"
#import "UIFont+AppFonts.h"
#import "UIColor+AppColors.h"

@implementation SubjectHeaderView

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) awakeFromNib {
    [super awakeFromNib];
    [self setupAppearance];
}

- (void) prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self setupAppearance];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupAppearance {
    self.titleLabel.font = [UIFont mainTitleFont_Regular];
    self.backgroundColor = [UIColor invision_lightGrayColor];
}


@end
