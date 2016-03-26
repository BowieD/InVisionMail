//
//  MenuCell.h
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuCellDataSource <NSObject>
- (NSString*) formattedTitle;
@end


@interface MenuCell : UITableViewCell

- (void) loadData: (id<MenuCellDataSource>) dataSource;

@end
