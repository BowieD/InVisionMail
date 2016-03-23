//
//  DrawerVCTests.m
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
#import "TestPanGestureRecognizer.h"

// Expose private properties and functions needed for testing
@interface DrawerVC (Private)

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainVCWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContainerLeftConstraint;

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *menuContainerView;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *panGestureRecognizer;

- (void) updateMainVCPosition: (CGFloat) position;

@end


SPEC_BEGIN(DrawerViewControllerTests)

describe(@"DrawerViewController", ^{
    
    __block DrawerVC* controller;
    
    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"DrawerViewController"];
    });
    
    // ------------  ------------  ------------  ------------  ------------  ------------
    // Dependencies
    
    context(@"when no custom dependencies are set", ^{
        it(@"should use UITapGestureRecognizer", ^{
            [[controller.tapGestureRecognizer should] beKindOfClass:[UITapGestureRecognizer class]];
        });

        it(@"should use UIPanGestureRecognizer", ^{
            [[controller.panGestureRecognizer should] beKindOfClass:[UIPanGestureRecognizer class]];
        });
    });
    
    context(@"when custom dependencies are set", ^{
        beforeEach(^{
            controller.TapGestureRecognizerClass = [TestTapGestureRecognizer class];
            controller.PanGestureRecognizerClass = [TestPanGestureRecognizer class];
        });
        
        it(@"should use custom dependency for tap gesture recognizer", ^{
            [[controller.tapGestureRecognizer should] beKindOfClass:[TestTapGestureRecognizer class]];
        });
        
        it(@"should use custom dependency for par gesture recognizer", ^{
            [[controller.panGestureRecognizer should] beKindOfClass:[TestPanGestureRecognizer class]];
        });
    });

    
    // ------------  ------------  ------------  ------------  ------------  ------------
    //
    
    context(@"when view is loaded", ^{
        beforeEach(^{
            // setup test dependencies
            controller.TapGestureRecognizerClass = [TestTapGestureRecognizer class];
            controller.PanGestureRecognizerClass = [TestPanGestureRecognizer class];
            
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
        
        context(@"after VC is presented", ^{
            beforeEach(^{
                controller.mainControllerOverlap = 50;
                [controller.view setNeedsUpdateConstraints];
                [controller.view updateConstraintsIfNeeded];
            });
            
            
            // ------------  ------------  ------------  ------------  ------------  ------------
            // mainVC Position
            
            it(@"should constraint values for mainVC position", ^{
                [controller updateMainVCPosition:-15];
                [[theValue(controller.mainContainerLeftConstraint.constant) should] equal:theValue(0)];

                CGFloat viewWidth = controller.view.frame.size.width;
                CGFloat maxPosition = viewWidth - controller.mainControllerOverlap;
                
                [controller updateMainVCPosition: maxPosition + 10];
                [[theValue(controller.mainContainerLeftConstraint.constant) should] equal:theValue(maxPosition)];
            });
            
            
            // ------------  ------------  ------------  ------------  ------------  ------------
            // When menu is hidden

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
                
                it(@"should disable tapGestureRecognizer", ^{
                    [[theValue(controller.tapGestureRecognizer.enabled) should] beFalse];
                });

                it(@"should disable panGestureRecognizer", ^{
                    [[theValue(controller.panGestureRecognizer.enabled) should] beFalse];
                });
            });
            
            
            
            // ------------  ------------  ------------  ------------  ------------  ------------
            // When menu is visible
            
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
                
                
                // ------------  ------------  ------------  ------------  ------------  ------------
                // Tap gesture
                
                describe(@"tap gesture recognizer", ^{
                    __block TestTapGestureRecognizer* recognizer;
                    
                    beforeEach(^{
                        recognizer = (TestTapGestureRecognizer*)controller.tapGestureRecognizer;
                    });
                    
                    it(@"should be added to the view", ^{
                        [[theValue([controller.view.gestureRecognizers containsObject:recognizer]) should] beTrue];
                    });
                    
                    it(@"should be enabled", ^{
                        [[theValue(controller.tapGestureRecognizer.enabled) should] beTrue];
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
                
                
                // ------------  ------------  ------------  ------------  ------------  ------------
                // Pan gesture
                
                describe(@"pan gesture recognizer", ^{
                    __block TestPanGestureRecognizer* recognizer;
                    
                    beforeEach(^{
                        recognizer = (TestPanGestureRecognizer*)controller.panGestureRecognizer;
                    });
                    
                    it(@"should be added to the view", ^{
                        [[theValue([controller.view.gestureRecognizers containsObject:recognizer]) should] beTrue];
                    });
                    
                    it(@"should be enabled", ^{
                        [[theValue(controller.tapGestureRecognizer.enabled) should] beTrue];
                    });
                    
                    // We cancel pan gestures not starting at the mainVC area
                    it(@"should cancel current gesture when user begin gesture outside the mainVC area", ^{
                        [[recognizer should] receive:@selector(cancel)];
                        
                        // point at the area of MainVC
                        CGPoint point = CGPointMake(controller.view.frame.size.width - (controller.mainControllerOverlap + 1), 1);
                        
                        [recognizer performTouchWithView:controller.view point:point state:UIGestureRecognizerStateBegan];
                    });

                    context(@"when gesture is not cancelled", ^{
                        it(@"should move mainVC at the current finger position and update layout", ^{
                            [[controller.view should] receive:@selector(layoutIfNeeded)];
                            
                            // point at the area of MainVC
                            CGPoint point = CGPointMake(100, 1);
                            [recognizer performTouchWithView:controller.view point:point state:UIGestureRecognizerStateChanged];
                            
                            [[theValue(controller.mainContainerLeftConstraint.constant) should] equal:theValue(100)];
                        });
                    });
                    
                    context(@"when gesture ended", ^{
                        context(@"with right direction", ^{
                            beforeEach(^{
                                recognizer.mockVelocity = CGPointMake(1000, 0);
                                [controller updateMainVCPosition:100]; // simulate unfinished gesture
                            });
                            
                            describe(@"animation", ^{
                                it(@"should be smooth", ^{
                                    // We want the animation speed to match the last known velocity of the gesture (as close as possible)
                                    __block NSTimeInterval realDuration = CGFLOAT_MAX;
                                    
                                    CGFloat finalPosition = controller.view.frame.size.width - controller.mainControllerOverlap;
                                    CGFloat distance = ABS(controller.mainContainerLeftConstraint.constant - finalPosition);
                                    NSTimeInterval idealDuration = (distance / ABS(recognizer.mockVelocity.x));
                                    
                                    [UIView stub:@selector(animateWithDuration:animations:) withBlock:^id(NSArray *params) {
                                        realDuration = ((NSNumber*)params[0]).doubleValue;
                                        void (^animations)(void) = params[1];
                                        animations();
                                        return nil; // because of compiler
                                    }];
                                    
                                    [[controller.view should] receive:@selector(layoutIfNeeded)];
                                    
                                    [recognizer performTouchWithView:controller.view point:CGPointMake(100, 100) state:UIGestureRecognizerStateEnded];
                                    
                                    [[theValue(realDuration) should] equal:idealDuration withDelta:0.1];
                                    [[expectFutureValue(theValue(controller.mainContainerLeftConstraint.constant)) should] equal:theValue(finalPosition)];
                                });
                                
                                it(@"shouldn't last longer then default animation when velocity is small", ^{
                                    recognizer.mockVelocity = CGPointMake(-0.01, 0);
                                    
                                    __block NSTimeInterval realDuration = CGFLOAT_MAX;
                                    
                                    [UIView stub:@selector(animateWithDuration:animations:) withBlock:^id(NSArray *params) {
                                        realDuration = ((NSNumber*)params[0]).doubleValue;
                                        void (^animations)(void) = params[1];
                                        animations();
                                        return nil; // because of compiler
                                    }];
                                    
                                    [recognizer performTouchWithView:controller.view point:CGPointMake(100, 100) state:UIGestureRecognizerStateEnded];
                                    
                                    [[theValue(realDuration) should] beLessThanOrEqualTo:theValue([controller defaultAnimationTime])];
                                });
                            });
                            
                            
                            it(@"keep menu opened", ^{
                                [recognizer performTouchWithView:controller.view point:CGPointMake(100, 100) state:UIGestureRecognizerStateEnded];

                                [[theValue(controller.menuOpened) should] beTrue];
                            });
                        });
                        
                        context(@"with left direction", ^{
                            beforeEach(^{
                                recognizer.mockVelocity = CGPointMake(-1000, 0);
                                [controller updateMainVCPosition:100]; // simulate unfinished gesture
                            });
                            
                            context(@"animation", ^{
                                it(@"should be smooth", ^{
                                    // We want the animation speed to match the last known velocity of the gesture (as close as possible)
                                    __block NSTimeInterval realDuration = CGFLOAT_MAX;
                                    
                                    CGFloat finalPosition = 0;
                                    CGFloat distance = ABS(controller.mainContainerLeftConstraint.constant - finalPosition);
                                    NSTimeInterval idealDuration = (distance / ABS(recognizer.mockVelocity.x));
                                    
                                    [UIView stub:@selector(animateWithDuration:animations:) withBlock:^id(NSArray *params) {
                                        realDuration = ((NSNumber*)params[0]).doubleValue;
                                        void (^animations)(void) = params[1];
                                        animations();
                                        return nil; // because of compiler
                                    }];
                                    
                                    [[controller.view should] receive:@selector(layoutIfNeeded)];
                                    
                                    [recognizer performTouchWithView:controller.view point:CGPointMake(100, 100) state:UIGestureRecognizerStateEnded];
                                    
                                    [[theValue(realDuration) should] equal:idealDuration withDelta:0.1];
                                    [[expectFutureValue(theValue(controller.mainContainerLeftConstraint.constant)) should] equal:theValue(finalPosition)];
                                });
                                
                                it(@"shouldn't last longer then default animation when velocity is small", ^{
                                    recognizer.mockVelocity = CGPointMake(-0.01, 0);
                                    
                                    __block NSTimeInterval realDuration = CGFLOAT_MAX;
                                    
                                    [UIView stub:@selector(animateWithDuration:animations:) withBlock:^id(NSArray *params) {
                                        realDuration = ((NSNumber*)params[0]).doubleValue;
                                        void (^animations)(void) = params[1];
                                        animations();
                                        return nil; // because of compiler
                                    }];
                                    
                                    [recognizer performTouchWithView:controller.view point:CGPointMake(100, 100) state:UIGestureRecognizerStateEnded];
                                    
                                    [[theValue(realDuration) should] beLessThanOrEqualTo:theValue([controller defaultAnimationTime])];
                                });
                            });
                            
                            it(@"should close menu", ^{
                                [recognizer performTouchWithView:controller.view point:CGPointMake(100, 100) state:UIGestureRecognizerStateEnded];

                                [[theValue(controller.menuOpened) should] beFalse];
                            });
                        });
                    });

                });
            });
        });
    });
});

SPEC_END