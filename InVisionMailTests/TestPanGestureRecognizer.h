//
//  TestPanGestureRecognizer.h
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic) CGPoint mockTappedPoint;
@property (nonatomic) UIView* mockTappedView;
@property (nonatomic) UIGestureRecognizerState mockState;

@property (nonatomic, weak) id mockTarget;
@property (nonatomic) SEL mockAction;

@property (nonatomic) CGPoint mockVelocity;

- (void) performTouchWithView: (UIView *)view point: (CGPoint)point state: (UIGestureRecognizerState) state;

@end
