//
//  UIColor+AppColors.h
//  InVisionMail
//
//  Created by Vojta Stavik on 26/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

// All colors used in the app

// We use invision_ prefix for custom colors to not mix them with system colors
@interface UIColor (AppColors)

+ (UIColor*) invision_textColor;

+ (UIColor*) invision_darkGrayColor;
+ (UIColor*) invision_lightGrayColor;
+ (UIColor*) invision_greenColor;

+ (UIColor*) invision_drawerBackgroundColor;
+ (UIColor*) invision_drawerTextColor;
+ (UIColor*) invision_drawerSelectedColor;
+ (UIColor*) invision_drawerHeaderColor;

@end
