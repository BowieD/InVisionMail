//
//  DrawerVC.h
//  InVisionMail
//
//  Created by Vojta Stavik on 21/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerVC : UIViewController <UISplitViewControllerDelegate>

@property (nullable, nonatomic, weak) UINavigationController* mainVC;
@property (nullable, nonatomic, weak) UINavigationController* menuVC;

@property (nonatomic) CGFloat mainControllerOverlap;
@property (nonatomic, readonly, getter=isMenuOpened) BOOL menuOpened;

- (void) showMenu;
- (void) hideMenu;


// Dependencies

// We have to provide custom subclass of recognizers for testing. The original implementation
// doesn't expose values we need. It's almost imposible to test it properly with it.
@property (nonatomic, strong) Class _Nonnull TapGestureRecognizerClass;
@property (nonatomic, strong) Class _Nonnull PanGestureRecognizerClass;

@end


// We create category for easy access to DrawerVC from child VCs
@interface UIViewController (DrawerAccess)

- ( DrawerVC* _Nullable ) drawerVC;

@end