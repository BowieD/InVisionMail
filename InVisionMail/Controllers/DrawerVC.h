//
//  DrawerVC.h
//  InVisionMail
//
//  Created by Vojta Stavik on 21/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerVC : UIViewController

@property (nullable, nonatomic, weak) UIViewController* mainVC;
@property (nullable, nonatomic, weak) UIViewController* menuVC;

@property (nonatomic) CGFloat mainControllerOverlap;
@property (nonatomic, readonly, getter=isMenuOpened) BOOL menuOpened;

- (void) showMenu;
- (void) hideMenu;

// Dependencies

// We have to provide custom subclass of recognizer for testing. The original implementation
// doesn't expose values we needed. It's almost imposible to test it properly.
@property (nonatomic, strong) Class _Nonnull TapGestureRecognizerClass;

@end

// We create Cathegory for easy access to DrawerVC from child VCs
@interface UIViewController (DrawerAccess)

- ( DrawerVC* _Nullable ) drawerVC;

@end