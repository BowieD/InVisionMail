//
//  InboxTableViewDataSource.m
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "InboxTableViewDataSource.h"
#import "Message.h"
#import "NSManagedObject+Helpers.h"
#import "UITableViewCell+Helpers.h"
#import "MessageListCell.h"

#import "TableViewDataSource.h"

@implementation TableViewDataSource (InboxTableViewDataSource)

+ (instancetype) inboxTableViewDataSource:(UITableView *)tableView context:(NSManagedObjectContext *)context {

    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:[Message entityName]];
    request.sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO] ];

    TableViewDataSource* dataSource = [[TableViewDataSource alloc] initWithTableView:tableView
                                                  context:context
                                             fetchRequest:request
                                       sectionNameKeyPath:nil
                                            tableViewCell:[MessageListCell class]
                                                   entity:[Message class]];
    
    return dataSource;
}

@end
