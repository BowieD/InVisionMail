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

@interface DrawerVC ()

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *menuContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContainerLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainVCWidthConstraint;

@property (nonatomic, readwrite) BOOL menuOpened;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end


@implementation DrawerVC

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.mainControllerOverlap = 80;
    [self setupTapGestureRecognizer];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupTapGestureRecognizer {
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setters & Getters

- (void) setMenuOpened:(BOOL)menuOpened {
    _menuOpened = menuOpened;
    
    if (_menuOpened) {
        self.mainVC.view.userInteractionEnabled = NO;
    } else {
        self.mainVC.view.userInteractionEnabled = YES;
    }
}

- (UITapGestureRecognizer*) tapGestureRecognizer {
    if (_tapGestureRecognizer == nil) {
        _tapGestureRecognizer = [[self.TapGestureRecognizerClass alloc] initWithTarget:self action:@selector(handleTap:)];
    }
    return _tapGestureRecognizer;
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
            self.mainContainerLeftConstraint.constant = distance;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void) hideMenu {
    if (self.isMenuOpened) {
        self.menuOpened = NO;
        [UIView animateWithDuration:[self defaultAnimationTime] animations:^{
            CGFloat distance = 0;
            self.mainContainerLeftConstraint.constant = distance;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void) handleTap: (UITapGestureRecognizer*) recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded
        && [self isPointAtTheAreaOfMainVC:[recognizer locationInView:self.view]])
    {
        [self hideMenu];
    }
}

- (BOOL) isPointAtTheAreaOfMainVC: (CGPoint) point {
    return point.x > (self.mainVCWidthConstraint.constant - self.mainControllerOverlap);
}

@end



#pragma mark - DrawerAccess cathegory

@implementation UIViewController (DrawerAccess)

- ( DrawerVC* _Nullable ) drawerVC {
    if ([self.parentViewController isKindOfClass:[DrawerVC class]]) {
        return (DrawerVC*)self.parentViewController;
    }
    return [self.parentViewController drawerVC]; // If parrentViewController is nil, returns nil
}

@end
