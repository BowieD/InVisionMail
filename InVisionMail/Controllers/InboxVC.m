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
#import "Segues.h"
#import "Message.h"
#import "MessageDetailVC.h"
#import "UIColor+AppColors.h"
#import "StatusInfoView.h"

@interface InboxVC () <UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet StatusInfoView *statusInfoView;
@property (nonatomic, strong) TableViewDataSource* dataSource;
@end

@implementation InboxVC

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Preferences

static CGFloat rowHeight = 80;



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
    
    BOOL silently = self.dataSource.frc.fetchedObjects.count != 0;
    [self getNewMessages:silently];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupNavigationItems {
    self.navigationItem.title = @"Inbox";
    
    // Hamburger button
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(hamburgerButtonPressed)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor invision_darkGrayColor];

    // New message button
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor invision_greenColor];
}


- (void) setupTableViewAndDatasource {
    self.dataSource = [TableViewDataSource inboxTableViewDataSource:self.tableView context:self.context];
    self.tableView.delegate = self;
    self.tableView.rowHeight = rowHeight;
}

- (void) setupAppearance {
    
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Networking

- (void) getNewMessages: (BOOL) silently {
    
    if (silently == NO) {
        [self.statusInfoView loading];
    }
    
    [self.communicator getMyMessagesToContext:self.context completion:^(NSError * _Nullable error) {
        if (error) {
            [self.statusInfoView error:error];
        } else {
            [self.statusInfoView success];
        }
    }];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_MESSAGE_DETAIL]) {
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
        if (selectedIndexPath != nil) {
            Message* message = [self.dataSource.frc objectAtIndexPath:selectedIndexPath];
            MessageDetailVC* detailVC = ((UINavigationController*)segue.destinationViewController).viewControllers.firstObject;
            detailVC.messageId = message.customId;
        }
    }
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - TableView delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Message* message = [self.dataSource.frc objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:SHOW_MESSAGE_DETAIL sender:message.customId];
}

@end
