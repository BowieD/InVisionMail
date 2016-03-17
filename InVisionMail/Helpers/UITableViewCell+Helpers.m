//
//  UITableViewCell+Helpers.m
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "UITableViewCell+Helpers.h"

@implementation UITableViewCell (Helpers)

+ (NSString*) reuseIdentifier {
    return NSStringFromClass(self);
}

+ (nullable UINib*) nib {
    return [UINib nibWithNibName:[self reuseIdentifier] bundle:[NSBundle bundleForClass:self]];
}

@end
