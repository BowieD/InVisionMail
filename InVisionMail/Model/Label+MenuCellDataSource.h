//
//  Label+MenuCellDataSource.h
//  InVisionMail
//
//  Created by Vojta Stavik on 26/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "Label.h"
#import "MenuCell.h"

@interface Label (MenuCellDataSource) <MenuCellDataSource>

- (NSString*) formattedTitle;

@end
