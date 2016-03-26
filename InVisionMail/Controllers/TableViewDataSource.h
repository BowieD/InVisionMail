//
//  TableViewDataSource.h
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

// Generic class combinig TableViewDataSource & FetchedResultsController

@protocol CellLoadable <NSObject>
- (void) loadData: (NSDictionary*) dataSource;
@end

@interface TableViewDataSource : NSObject

- (instancetype) initWithTableView: (UITableView *)tableView
                           context: (NSManagedObjectContext *)context
                      fetchRequest: (NSFetchRequest *)request
                sectionNameKeyPath: (NSString*)sectionNameKeyPath
                     tableViewCell: (Class<CellLoadable>)cellClass
                            entity: (Class)entityClass;

@property (nonatomic, strong, readonly) NSFetchedResultsController* frc;

@end
