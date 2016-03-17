//
//  IVMInboxVC.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "InboxVC.h"
#import "InboxTableViewDataSource.h"

@interface InboxVC () <UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) InboxTableViewDataSource* dataSource;
@end

@implementation InboxVC

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[InboxTableViewDataSource alloc] initWithTableView:self.tableView context:self.context];
    self.tableView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.communicator getMyMessagesToContext:self.context];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Dependencies

- (APICommunicator *) communicator {
    if (_communicator == nil) {
        // Dependency not set, use default communicator
        _communicator = [APICommunicator sharedCommunicator];
    }
    return _communicator;
}

- (NSManagedObjectContext *) context {
    if (_context == nil) {
        // Dependency not set, use default context
        _context = [CoreDataStack sharedInstance].mainContext;
    }
    return _context;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - TableView delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



@end
