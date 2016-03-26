//
//  StatusInfoLabel.h
//  InVisionMail
//
//  Created by Vojta Stavik on 26/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 View to inform user about loading, errors, etc.
 */
@interface StatusInfoView : UIView

// Show loading state
- (void) loading;

// Hide label
- (void) success;

// Shows error message for 3 seconds
- (void) error: ( NSError* _Nullable ) error;

@end
