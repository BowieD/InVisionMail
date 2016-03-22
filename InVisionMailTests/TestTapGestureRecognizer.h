//
//  TestTapGestureRecognizer.h
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic) CGPoint mockTappedPoint;
@property (nonatomic) UIView* mockTappedView;

@property (nonatomic, weak) id mockTarget;
@property (nonatomic) SEL mockAction;

-(void) performTapWithView: (UIView *)view andPoint: (CGPoint)point;

@end
