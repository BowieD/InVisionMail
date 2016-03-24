//
//  MainSplitVC.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MainSplitVC.h"

@interface MainSplitVC () <UISplitViewControllerDelegate>

@end

@implementation MainSplitVC

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupAppearance {
    self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
}



@end
