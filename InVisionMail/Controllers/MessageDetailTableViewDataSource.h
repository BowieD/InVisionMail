//
//  MessageDetailTableViewDataSource.h
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewDataSource.h"

@interface TableViewDataSource (MessageDetailTableViewDataSource)

+ (instancetype) messageDetailTableViewDataSource:(UITableView *)tableView
                                         threadId: (NSString*) threadId
                                          context:(NSManagedObjectContext *)context;

@end
