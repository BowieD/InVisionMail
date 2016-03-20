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

@interface InboxTableViewDataSource () <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic, strong) NSFetchedResultsController* frc;

@end

@implementation InboxTableViewDataSource

- (instancetype) initWithTableView: (UITableView*)tableView context: (NSManagedObjectContext*)context {
    if (self = [super init]) {
        [self prepareFRC: context];
        [self prepareTableView: tableView];
    }
    return self;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup methods

- (void) prepareTableView: (UITableView*)tableView {
    self.tableView = tableView;
    [self.tableView registerNib:[MessageListCell nib] forCellReuseIdentifier:[MessageListCell reuseIdentifier]];
    tableView.dataSource = self;
}

- (void) prepareFRC: (NSManagedObjectContext*) context {
    self.context = context;
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
    if (_frc == nil && self.context != nil) {
        NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:[Message entityName]];
        request.sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO] ];
        
        _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];

    }
    return _frc;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.frc.fetchedObjects.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListCell* cell = (MessageListCell*)[tableView dequeueReusableCellWithIdentifier:[MessageListCell reuseIdentifier] forIndexPath:indexPath];
    
    Message* m = [self.frc objectAtIndexPath:indexPath];
    [cell loadData: [self.frc objectAtIndexPath:indexPath]];
    
    return cell;
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
        MessageListCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell loadData:anObject];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end
