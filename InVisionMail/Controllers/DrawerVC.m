//
//  DrawerVC.m
//  InVisionMail
//
//  Created by Vojta Stavik on 21/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "DrawerVC.h"
#import "Segues.h"
#import "UIViewController+Animations.h"
#import "UIGestureRecognizer+Cancel.h"

@interface DrawerVC () <UISplitViewControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *menuContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContainerLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainVCWidthConstraint;

@property (nonatomic, readwrite) BOOL menuOpened;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UIViewController* detail;

@end


@implementation DrawerVC

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.menuOpened = NO;
    
    [self setupGestureRecognizers];
    [self setupAppearance];

    self.splitViewController.delegate = self;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupAppearance {
    self.mainControllerOverlap = 80;
    self.view.layer.masksToBounds = YES;
}

- (void) setupGestureRecognizers {
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setters & Getters

- (void) setMenuOpened:(BOOL)menuOpened {
    _menuOpened = menuOpened;
    
    if (_menuOpened) {
        self.mainVC.view.userInteractionEnabled = NO;
        self.tapGestureRecognizer.enabled = YES;
        self.panGestureRecognizer.enabled = YES;
    } else {
        self.mainVC.view.userInteractionEnabled = YES;
        self.tapGestureRecognizer.enabled = NO;
        self.panGestureRecognizer.enabled = NO;
    }
}

- (UITapGestureRecognizer*) tapGestureRecognizer {
    if (_tapGestureRecognizer == nil) {
        _tapGestureRecognizer = [[self.TapGestureRecognizerClass alloc] initWithTarget:self action:@selector(handleTap:)];
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}

- (UIPanGestureRecognizer*) panGestureRecognizer {
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[self.PanGestureRecognizerClass alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Dependencies

- (Class) TapGestureRecognizerClass {
    if (_TapGestureRecognizerClass == nil) {
        // no dependency set, use default value
        _TapGestureRecognizerClass = [UITapGestureRecognizer class];
    }
    return _TapGestureRecognizerClass;
}

- (Class) PanGestureRecognizerClass {
    if (_PanGestureRecognizerClass == nil) {
        // no dependency set, use default value
        _PanGestureRecognizerClass = [UIPanGestureRecognizer class];
    }
    return _PanGestureRecognizerClass;
}



// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Layout

- (void) updateViewConstraints {
    [super updateViewConstraints];
    self.mainVCWidthConstraint.constant = self.view.frame.size.width;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DRAWER_EMBEDED_MENU]) {
        self.menuVC = segue.destinationViewController;
        
    } else if ([segue.identifier isEqualToString:DRAWER_EMBEDED_MAIN]) {
        self.mainVC = segue.destinationViewController;
    }
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Open/Close menu logic

- (void) showMenu {
    if (self.isMenuOpened == NO) {
        self.menuOpened = YES;
        [UIView animateWithDuration:[self defaultAnimationTime] animations:^{
            CGFloat distance = self.mainVCWidthConstraint.constant - self.mainControllerOverlap;
            [self updateMainVCPosition: distance];
            [self.view layoutIfNeeded];
        }];
    }
}

- (void) hideMenu {
    if (self.isMenuOpened) {
        self.menuOpened = NO;
        [UIView animateWithDuration:[self defaultAnimationTime] animations:^{
            CGFloat distance = 0;
            [self updateMainVCPosition: distance];
            [self.view layoutIfNeeded];
        }];
    }
}

- (void) updateMainVCPosition: (CGFloat) position {
    CGFloat minValue = 0;
    CGFloat maxValue = self.view.frame.size.width - self.mainControllerOverlap;
    
    self.mainContainerLeftConstraint.constant = MIN(maxValue, MAX(position, minValue));
}

- (void) handleTap: (UITapGestureRecognizer*) recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded
        && [self isPointAtTheAreaOfMainVC:[recognizer locationInView:self.view]])
    {
        [self hideMenu];
    }
}

- (void) handlePan: (UIPanGestureRecognizer*) recognizer {
    CGPoint currentPoint = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan
        && NO == [self isPointAtTheAreaOfMainVC:currentPoint])
    {
        // We ignore pan gesture starting outside the mainVC area
        [recognizer cancel];
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self updateMainVCPosition:currentPoint.x];
        [self.view layoutIfNeeded];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat xVelocity = [recognizer velocityInView:self.view].x;
        if (xVelocity > 0) {
            [self finishOpenAnimationWithVelocity:ABS(xVelocity)];
        } else {
            [self finishCloseAnimationWithVelocity:ABS(xVelocity)];
        }
    }
}

- (BOOL) isPointAtTheAreaOfMainVC: (CGPoint) point {
    return point.x > (self.mainVCWidthConstraint.constant - self.mainControllerOverlap);
}

- (void) finishOpenAnimationWithVelocity: (CGFloat)xVelocity {
    CGFloat finalPosition = self.view.frame.size.width - self.mainControllerOverlap;
    [self finishAnimationWithFinalPostion:finalPosition velocity:xVelocity];
}

- (void) finishCloseAnimationWithVelocity: (CGFloat)xVelocity {
    CGFloat finalPosition = 0;
    [self finishAnimationWithFinalPostion:finalPosition velocity:xVelocity];
    self.menuOpened = NO;
}

- (void) finishAnimationWithFinalPostion: (CGFloat) finalPosition velocity: (CGFloat) velocity {
    CGFloat missingDistance = ABS(finalPosition - self.mainContainerLeftConstraint.constant);
    
    NSTimeInterval duration = MIN([self defaultAnimationTime], missingDistance / velocity);
    
    [UIView animateWithDuration:duration animations:^{
        [self updateMainVCPosition:finalPosition];
        [self.view layoutIfNeeded];
    }];
}

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - UISplitViewController delegate + tweaks

// We use DrawerVC as the Master view controller for Split view controller. Bacuse this class
// is not a subclass of UINavigationController, we have to manually handle the way, how the detail
// VC is presented

- (void) showDetailViewController:(UIViewController *)vc sender:(id)sender {
    UIViewController* detailVC = vc;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        // we can't push a navigation controller, just the root VC
        detailVC = ((UINavigationController*)detailVC).viewControllers.firstObject;
    }

    if (detailVC != nil) {
        self.detail = detailVC;
    }

    if (self.splitViewController.isCollapsed) {
        // If SplitVC is collapsed (iPhone), we push the detailVC from MainVC
        [self.mainVC pushViewController:detailVC animated:YES];

    } else {
        // SplitVC is not collapsed (iPad), we let splitViewControlled decide what to do
        [self.splitViewController showDetailViewController:vc sender:sender];
    }
}

- (UIViewController*) splitViewController:(UISplitViewController *)splitViewController separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController {
    
    return [[UINavigationController alloc] initWithRootViewController:self.detail];
}

- (UIViewController*) primaryViewControllerForCollapsingSplitViewController:(UISplitViewController *)splitViewController {

    [self.mainVC popToRootViewControllerAnimated:NO];
    
    if (self.detail != nil) {
        [self.mainVC pushViewController:self.detail animated:NO];
    }

    return self;
}

- (UIViewController*) primaryViewControllerForExpandingSplitViewController:(UISplitViewController *)splitViewController {

    [self.mainVC popToRootViewControllerAnimated:NO];
    return self;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.menuVC.view]) {
        // We don't want to cancle menuVC touches
        return NO;
    }
    return YES;
}

@end



#pragma mark - DrawerAccess category

@implementation UIViewController (DrawerAccess)

- (DrawerVC* _Nullable) drawerVC {
    if ([self.parentViewController isKindOfClass:[DrawerVC class]]) {
        return (DrawerVC*)self.parentViewController;
    }
    return [self.parentViewController drawerVC]; // If parrentViewController is nil, returns nil
}

@end
