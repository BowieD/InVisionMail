//
//  IVMInboxVC.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "InboxVC.h"
#import "InboxTableViewDataSource.h"
#import "DrawerVC.h"


@interface InboxVC () <UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) TableViewDataSource* dataSource;
@end

@implementation InboxVC

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Preferences

static CGFloat rowHeight = 100;



// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItems];
    [self setupTableViewAndDatasource];
    [self setupAppearance];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.communicator getMyMessagesToContext:self.context];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupNavigationItems {
    self.navigationItem.title = @"Inbox";
    
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(hamburgerButtonPressed)];
}

- (void) setupTableViewAndDatasource {
    self.dataSource = [TableViewDataSource inboxTableViewDataSource:self.tableView context:self.context];
    self.tableView.delegate = self;
}

- (void) setupAppearance {

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
#pragma mark - Navigation

- (void) hamburgerButtonPressed {
    [[self drawerVC] showMenu];
}



// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - TableView delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}



@end
