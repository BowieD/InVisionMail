//
//  RoundedView.m
//  InVisionMail
//
//  Created by Vojta Stavik on 25/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "RoundedView.h"

@implementation RoundedView

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
}

@end
