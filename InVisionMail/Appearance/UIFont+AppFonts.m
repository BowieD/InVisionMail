//
//  UIFont+AppFonts.m
//  InVisionMail
//
//  Created by Vojta Stavik on 25/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "UIFont+AppFonts.h"

@implementation UIFont (AppFonts)

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - MainTitle

static CGFloat mainTitleSize = 17;

+ (UIFont*) mainTitleFont_Regular {
    return [UIFont systemFontOfSize:mainTitleSize];
}

+ (UIFont*) mainTitleFont_Bold {
    return [UIFont boldSystemFontOfSize:mainTitleSize];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Regular text

static CGFloat regularTextSize = 13;

+ (UIFont*) regularTextFont_Regular {
    return [UIFont systemFontOfSize:regularTextSize];
}

+ (UIFont*) regularTextFont_Bold {
    return [UIFont boldSystemFontOfSize:regularTextSize];
}



// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Regular text

static CGFloat footnoteTextSize = 11;

+ (UIFont*) footnoteFont_Regular {
    return [UIFont systemFontOfSize:footnoteTextSize];
}

+ (UIFont*) footnoteFont_Bold {
    return [UIFont boldSystemFontOfSize:footnoteTextSize];
}




@end
