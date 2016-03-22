//
//  TestPanGestureRecognizer.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

// We can ignore warning about potential leaking selectors for unit tests
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#import "TestPanGestureRecognizer.h"

@implementation TestPanGestureRecognizer

-(id)initWithTarget:(id)target action:(SEL)action {
    self.mockTarget = target;
    self.mockAction =  action;
    
    return [super initWithTarget:target action:action];
}

-(UIView *)view {
    return self.mockTappedView;
}

-(CGPoint)locationInView:(UIView *)view {
    return [self.view convertPoint:self.mockTappedPoint fromView:self.mockTappedView];
}

-(CGPoint)velocityInView:(UIView *)view {
    return self.mockVelocity;
}

-(UIGestureRecognizerState)state {
    return self.mockState;
}

-(void) performTouchWithView: (UIView*)view point: (CGPoint)point state: (UIGestureRecognizerState)state {
    self.mockTappedView = view;
    self.mockTappedPoint = point;
    self.mockState = state;
    [self.mockTarget performSelector:self.mockAction withObject:self];
}

@end
