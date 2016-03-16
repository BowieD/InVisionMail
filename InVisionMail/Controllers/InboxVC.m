//
//  IVMInboxVC.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "InboxVC.h"

@interface InboxVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation InboxVC

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.communicator getMyMessagesToContext:self.context];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Dependencies

- (APICommunicator *) communicator {
    if (_communicator) {
        // Dependency not set, use default communicator
        _communicator = [APICommunicator sharedCommunicator];
    }
    return _communicator;
}

- (NSManagedObjectContext *) context {
    if (_context) {
        // Dependency not set, use default context
        _context = [CoreDataStack sharedInstance].mainContext;
    }
    return _context;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setters & Getters



@end
