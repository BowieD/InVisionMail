//
//  MenuTableViewDatasource.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MenuTableViewDatasource.h"
#import "Label.h"
#import "NSManagedObject+Helpers.h"
#import "MenuCell.h"

@implementation TableViewDataSource (MenuTableViewDatasource)

+ (instancetype) menuTableViewDataSource:(UITableView *)tableView context:(NSManagedObjectContext *)context {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:[Label entityName]];
    request.sortDescriptors = @[
                                [[NSSortDescriptor alloc] initWithKey:@"category" ascending:NO],
                                [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES],
                                [[NSSortDescriptor alloc] initWithKey:@"customId" ascending:YES]
                                ];
    
    TableViewDataSource* dataSource = [[TableViewDataSource alloc] initWithTableView:tableView
                                                                             context:context
                                                                        fetchRequest:request
                                                                  sectionNameKeyPath:@"category"
                                                                       tableViewCell:[MenuCell class]
                                                                              entity:[Label class]];
    
    return dataSource;
}


@end
