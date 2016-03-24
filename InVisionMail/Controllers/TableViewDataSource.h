//
//  TableViewDataSource.h
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TableViewDataSource : NSObject

- (instancetype) initWithTableView: (UITableView *)tableView
                           context: (NSManagedObjectContext *)context
                      fetchRequest: (NSFetchRequest *)request
                sectionNameKeyPath: (NSString*)sectionNameKeyPath
                     tableViewCell: (Class)cellClass
                            entity: (Class)entityClass;

@property (nonatomic, strong, readonly) NSFetchedResultsController* frc;

@end
