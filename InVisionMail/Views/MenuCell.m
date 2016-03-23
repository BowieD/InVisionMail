//
//  MenuCell.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (void) prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = nil;
}

- (void) loadData: (id<MenuCellDataSource>) dataSource {
    self.titleLabel.text = dataSource.title;
}

@end
