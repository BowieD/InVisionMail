//
//  Label+MenuCellDataSource.m
//  InVisionMail
//
//  Created by Vojta Stavik on 26/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "Label+MenuCellDataSource.h"

@implementation Label (MenuCellDataSource)

- (NSString*) formattedTitle {
    // We need title to be capitalized
    return [[self.title lowercaseString] capitalizedString];
}

@end
