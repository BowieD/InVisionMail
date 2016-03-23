//
//  MenuTableViewDatasource.h
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "TableViewDatasource.h"

@interface TableViewDataSource (MenuTableViewDatasource)

+ (instancetype) menuTableViewDataSource: (UITableView*)tableView context: (NSManagedObjectContext*)context;

@end
