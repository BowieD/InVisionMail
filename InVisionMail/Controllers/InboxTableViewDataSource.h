//
//  InboxTableViewDataSource.h
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface InboxTableViewDataSource : NSObject

- (instancetype) initWithTableView: (UITableView*)tableView context: (NSManagedObjectContext*)context;

@end
