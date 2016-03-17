//
//  UITableViewCell+Helpers.h
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Helpers)

+ (nonnull NSString*) reuseIdentifier;
+ (nullable UINib*) nib;

@end
