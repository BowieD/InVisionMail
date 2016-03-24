//
//  TableViewDataSource.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "TableViewDataSource.h"
#import "Message.h"
#import "NSManagedObject+Helpers.h"
#import "UITableViewCell+Helpers.h"
#import "MessageListCell.h"

@protocol CellLoadable <NSObject>
- (void) loadData: (NSDictionary*) dataSource;
@end


@interface TableViewDataSource () <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic, strong, readwrite) NSFetchedResultsController* frc;
@property (nonatomic, strong) NSFetchRequest* fetchRequest;
@property (nonatomic, strong) NSString* sectionNameKeyPath;

@property (nonatomic) Class entity;
@property (nonatomic) Class cell;

@end

@implementation TableViewDataSource

- (instancetype) initWithTableView:(UITableView *)tableView context:(NSManagedObjectContext *)context fetchRequest:(NSFetchRequest *)request sectionNameKeyPath: (NSString*) sectionNameKeyPath tableViewCell: (Class) cellClass entity: (Class) entityClass {

    NSAssert([entityClass isSubclassOfClass:[NSManagedObject class]], @"Enitiy class has to be subclass of NSManagedObject");
    NSAssert([cellClass isSubclassOfClass:[UITableViewCell class]], @"Cell class has to be subclass of UITableViewCell");

    if (self = [super init]) {
        self.entity = entityClass;
        self.cell = cellClass;
        [self prepareFRCWithRequest: request sectionNameKeyPath: sectionNameKeyPath context: context];
        [self prepareTableViewForCell: cellClass tableView: tableView];
    }
    return self;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup methods

- (void) prepareTableViewForCell: (Class) cellClass tableView: (UITableView*)tableView {
    self.tableView = tableView;
    [self.tableView registerNib:[cellClass nib] forCellReuseIdentifier:[cellClass reuseIdentifier]];
    self.tableView.dataSource = self;
}

- (void) prepareFRCWithRequest: (NSFetchRequest*)request sectionNameKeyPath: (NSString*) sectionNameKeyPath context: (NSManagedObjectContext*)context {
    self.context = context;
    self.fetchRequest = request;
    self.sectionNameKeyPath = sectionNameKeyPath;
    self.frc.delegate = self;
    
    NSError* error = nil;
    [self.frc performFetch:&error];
    
    if (error != nil) {
        NSLog(@"%@", error.description);
        // TODO: handle error
    }
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setters & Getters

- (NSFetchedResultsController*) frc {
    if (_frc == nil && self.context != nil && self.fetchRequest != nil) {
        _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                   managedObjectContext:self.context
                                                     sectionNameKeyPath:self.sectionNameKeyPath
                                                              cacheName:nil];
        
    }
    return _frc;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.frc.sections.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = (MessageListCell*)[tableView dequeueReusableCellWithIdentifier:[self.cell reuseIdentifier] forIndexPath:indexPath];
    
    id<CellLoadable> loadableCell = (id<CellLoadable>)cell;
    [loadableCell loadData: [self.frc objectAtIndexPath:indexPath]];
    
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.sectionNameKeyPath == nil) {
        return nil;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return sectionInfo.name;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - FetchedResultsController delegate

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    // There's a bug in iOS8, when FRC sometimes calls 'insert' instead of 'update'.
    // That's why we also check if newIndexPath exists.
    if (type == NSFetchedResultsChangeInsert && newIndexPath != nil) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (type == NSFetchedResultsChangeUpdate && newIndexPath == nil) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (type == NSFetchedResultsChangeMove && indexPath != nil && newIndexPath != nil) {
        // if cell is visible, update it
        id<CellLoadable> cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell loadData:anObject];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
}

- (void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end
