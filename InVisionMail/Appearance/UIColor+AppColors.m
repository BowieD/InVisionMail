//
//  UIColor+AppColors.m
//  InVisionMail
//
//  Created by Vojta Stavik on 26/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

+ (UIColor*) invision_textColor {
    static UIColor* color = nil;
    if (color == nil) {
        color = [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
    }
    return color;
}

+ (UIColor*) invision_darkGrayColor {
    static UIColor* color = nil;
    if (color == nil) {
        color = [UIColor colorWithRed:0.314 green:0.314 blue:0.314 alpha:1.00];
    }
    return color;
}

+ (UIColor*) invision_lightGrayColor {
    static UIColor* color = nil;
    if (color == nil) {
        color = [UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1.00];
    }
    return color;
}

+ (UIColor*) invision_greenColor {
    static UIColor* color = nil;
    if (color == nil) {
        color = [UIColor colorWithRed:0.098 green:0.729 blue:0.596 alpha:1.00];
    }
    return color;
}

+ (UIColor*) invision_drawerBackgroundColor {
    static UIColor* color = nil;
    if (color == nil) {
        color = [UIColor colorWithRed:0.204 green:0.192 blue:0.227 alpha:1.00];
    }
    return color;
}

+ (UIColor*) invision_drawerTextColor {
    static UIColor* color = nil;
    if (color == nil) {
        color = [UIColor colorWithRed:0.620 green:0.596 blue:0.663 alpha:1.00];
    }
    return color;
}

+ (UIColor*) invision_drawerSelectedColor {
    static UIColor* color = nil;
    if (color == nil) {
        color = [UIColor colorWithRed:0.263 green:0.525 blue:0.961 alpha:1.00];
    }
    return color;
}

+ (UIColor*) invision_drawerHeaderColor {
    static UIColor* color = nil;
    if (color == nil) {
        color = [UIColor colorWithRed:0.231 green:0.220 blue:0.255 alpha:1.00];
    }
    return color;
}

@end
