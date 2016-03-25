//
//  MessageDetailTableViewDataSource.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageDetailTableViewDataSource.h"
#import "Message.h"
#import "NSManagedObject+Helpers.h"
#import "MessageDetailPreviewCell.h"

@implementation TableViewDataSource (MenuTableViewDatasource)

+ (instancetype) messageDetailTableViewDataSource:(UITableView *)tableView
                                         threadId: (NSString*) threadId
                                          context:(NSManagedObjectContext *)context {

    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:[Message entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"threadId == %@", threadId];

    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO]];
    
    TableViewDataSource* dataSource = [[TableViewDataSource alloc] initWithTableView:tableView
                                                                             context:context
                                                                        fetchRequest:request
                                                                  sectionNameKeyPath:nil
                                                                       tableViewCell:[MessageDetailPreviewCell class]
                                                                              entity:[Message class]];
    
    return dataSource;
}


@end
