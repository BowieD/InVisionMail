//
//  UIGestureRecognizer+Cancel.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "UIGestureRecognizer+Cancel.h"

@implementation UIGestureRecognizer (Cancel)

- (void) cancel {
    self.enabled = NO;
    self.enabled = YES;
}

@end
