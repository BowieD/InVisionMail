//
//  LabelWithLoading.m
//  InVisionMail
//
//  Created by Vojta Stavik on 26/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "LabelWithLoading.h"
#import "UIColor+AppColors.h"

@implementation LabelWithLoading

- (void) setText:(NSString *)text {
    [super setText:text];
    
    if (text == nil) {
        self.backgroundColor = [[UIColor invision_lightGrayColor] colorWithAlphaComponent:0.5];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
