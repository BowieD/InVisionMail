//
//  TimestampLabel.m
//  InVisionMail
//
//  Created by Vojta Stavik on 25/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "TimestampLabel.h"
#import "UIFont+AppFonts.h"

@implementation TimestampLabel

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self applyAppearance];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self applyAppearance];
    }
    return self;
}

- (void) applyAppearance {
    self.font = [UIFont footnoteFont_Regular];
}

@end
