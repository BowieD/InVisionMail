//
//  MenuCell.h
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuCellDataSource <NSObject>

- (NSString*) title;

@end

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void) loadData: (id<MenuCellDataSource>) dataSource;

@end
