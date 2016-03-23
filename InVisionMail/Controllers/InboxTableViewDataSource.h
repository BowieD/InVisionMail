//
//  InboxTableViewDataSource.h
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TableViewDatasource.h"

@interface TableViewDataSource (InboxTableViewDataSource)

+ (instancetype) inboxTableViewDataSource: (UITableView*)tableView context: (NSManagedObjectContext*)context;

@end
