//
//  MenuSectionHeader.h
//  InVisionMail
//
//  Created by Vojta Stavik on 26/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuSectionHeader : UITableViewHeaderFooterView

+ (nonnull NSString*) reuseIdentifier;
+ (nullable UINib*) nib;

- (void) setTitle: (nullable NSString*)title;

@end
