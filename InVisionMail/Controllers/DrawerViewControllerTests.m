//
//  DrawerViewControllerTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 21/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "DrawerVC.h"
#import "MenuVC.h"
#import "InboxVC.h"
#import "UIViewController+Animations.h"
#import "TestTapGestureRecognizer.h"

// Expose private properties and functions needed for testing
@interface DrawerVC (Private)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainVCWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContainerLeftConstraint;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *menuContainerView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@end


SPEC_BEGIN(DrawerViewControllerTests)

describe(@"DrawerViewController", ^{
    
    __block DrawerVC* controller;
    
    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"DrawerViewController"];
    });
    
    context(@"when no custom dependency is set", ^{
        it(@"should use UITapGestureRecognizer", ^{
            [[controller.tapGestureRecognizer should] beKindOfClass:[UITapGestureRecognizer class]];
        });
    });
    
    context(@"when custom dependency is set", ^{
        beforeEach(^{
            controller.TapGestureRecognizerClass = [TestTapGestureRecognizer class];
        });
        
        it(@"should use custom dependency for tap gesture recognizer", ^{
            [[controller.tapGestureRecognizer should] beKindOfClass:[TestTapGestureRecognizer class]];
        });
    });

    context(@"when view is loaded", ^{
        beforeEach(^{
            // setup test dependencies
            controller.TapGestureRecognizerClass = [TestTapGestureRecognizer class];

            UIView* __unused view = controller.view;
            [controller beginAppearanceTransition:YES animated:NO];
            [controller endAppearanceTransition];
        });
        
        it(@"should have mainContainerView above menuContainerView in the view hierarchy", ^{
            NSInteger mainContainerIndex = [controller.view.subviews indexOfObject:controller.mainContainerView];
            NSInteger menuContainerIndex = [controller.view.subviews indexOfObject:controller.menuContainerView];
            
            [[theValue(mainContainerIndex) should] beGreaterThan: theValue(menuContainerIndex)];
        });
        
        it(@"should have UINavigationController with InboxVC as the main VC", ^{
            UINavigationController* navController = (UINavigationController*)controller.mainVC;
            [[navController.viewControllers.firstObject should] beKindOfClass:[InboxVC class]];
        });
        
        it(@"should have MenuVC the menu VC", ^{
            [[controller.menuVC should] beKindOfClass:[MenuVC class]];
        });
        
        it(@"should update mainVC width constraint to match width of drawerVC", ^{
            CGRect frame = controller.view.frame;
            frame.size.width = 123;
            controller.view.frame = frame;
            
            [controller.view setNeedsUpdateConstraints];
            [controller.view updateConstraintsIfNeeded];
            
            [[expectFutureValue(theValue(controller.mainVCWidthConstraint.constant)) shouldEventually] equal:theValue(123)];
        });
        
        it(@"should have mainControllerOverlap 80", ^{
            [[theValue(controller.mainControllerOverlap) should] equal:theValue(80)];
        });
        
        context(@"when not inside a non-collapsed SplitVC", ^{
            beforeEach(^{
                controller.mainControllerOverlap = 50;
                [controller.view setNeedsUpdateConstraints];
                [controller.view updateConstraintsIfNeeded];
            });
            
            context(@"when menu is hidden", ^{
                beforeEach(^{
                    [controller hideMenu];
                });
                
                it(@"should move mainVC to left by view.width - mainControllerOverlap when showMenu is called", ^{
                    [controller showMenu];
                    [[theValue(controller.mainContainerLeftConstraint.constant) should] equal:theValue(controller.mainVCWidthConstraint.constant - 50)];
                });
                
                it(@"should use the default animation length value for open animations", ^{
                    __block NSTimeInterval duration;
                    [UIView stub:@selector(animateWithDuration:animations:) withBlock:^id(NSArray *params) {
                        duration = ((NSNumber*)params[0]).doubleValue;
                        return nil; // because of compiler
                    }];
                    
                    [controller showMenu];
                    
                    [[expectFutureValue(theValue(duration)) should] equal:[controller defaultAnimationTime] withDelta: 0.01];
                });
                
                it(@"should keep closed when hideMenu is called", ^{
                    [controller hideMenu];
                    [[theValue(controller.mainContainerLeftConstraint.constant) should] equal:theValue(0)];
                });
                
                it(@"should enable user interaction on the mainVC", ^{
                    [[theValue(controller.mainVC.view.userInteractionEnabled) should] beTrue];
                });
            });
            
            context(@"when menu is visible", ^{
                beforeEach(^{
                    [controller showMenu];
                });
                
                it(@"should move mainVC completely to left when hideMenu is called", ^{
                    [controller hideMenu];
                    [[theValue(controller.mainContainerLeftConstraint.constant) should] equal:theValue(0)];
                });
                
                it(@"should keep open when showMenu is called", ^{
                    [controller showMenu];
                    [[theValue(controller.mainContainerLeftConstraint.constant) should] equal:theValue(controller.mainVCWidthConstraint.constant - 50)];
                });
                
                it(@"should use the default animation length value for close animations", ^{
                    __block NSTimeInterval duration;
                    [UIView stub:@selector(animateWithDuration:animations:) withBlock:^id(NSArray *params) {
                        duration = ((NSNumber*)params[0]).doubleValue;
                        return nil; // because of compiler
                    }];
                    
                    [controller hideMenu];
                    
                    [[expectFutureValue(theValue(duration)) should] equal:[controller defaultAnimationTime] withDelta: 0.01];
                });
                
                it(@"should disable user interaction on the mainVC", ^{
                    [[theValue(controller.mainVC.view.userInteractionEnabled) should] beFalse];
                });
                
                describe(@"tap gesture recognizer", ^{
                    __block TestTapGestureRecognizer* recognizer;
                    
                    beforeEach(^{
                        recognizer = (TestTapGestureRecognizer*)controller.tapGestureRecognizer;
                    });
                    
                    it(@"should be added to the view", ^{
                        [[theValue([controller.view.gestureRecognizers containsObject:recognizer]) should] beTrue];
                    });
                    
                    it(@"should close menu when user tap on the mainVC area", ^{
                        [[controller should] receive:@selector(hideMenu)];
                        
                        // point at the area of MainVC
                        CGPoint point = CGPointMake(controller.view.frame.size.width - (controller.mainControllerOverlap - 1), 1);

                        [recognizer performTapWithView:controller.view andPoint:point];
                    });
                    
                    it(@"should do nothing menu when user tap on the menuVC area", ^{
                        [[controller shouldNot] receive:@selector(showMenu)];
                        [[controller shouldNot] receive:@selector(hideMenu)];
                        
                        // point at the area of MenuVC
                        CGPoint point = CGPointMake(controller.view.frame.size.width - (controller.mainControllerOverlap + 1), 1);
                        
                        [recognizer performTapWithView:controller.view andPoint:point];
                    });
                });
            });
        });
    });
});

SPEC_END