//
//  TimestampLabel.m
//  InVisionMail
//
//  Created by Vojta Stavik on 25/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "TimestampLabel.h"
#import "UIFont+AppFonts.h"
#import "UIColor+AppColors.h"

@implementation TimestampLabel

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupAppearance];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupAppearance];
    }
    return self;
}

- (void) prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self setupAppearance];
}

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupAppearance {
    self.font = [UIFont footnoteFont_Regular];
    self.textColor = [UIColor invision_textColor];
}

@end
