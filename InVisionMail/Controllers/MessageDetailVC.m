//
//  MessageDetailVC.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageDetailVC.h"
#import "SubjectHeaderView.h"
#import "Message.h"
#import "CoreDataStack.h"
#import "NSManagedObject+Helpers.h"

@interface MessageDetailVC ()
@property (nonatomic, strong) Message* message;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SubjectHeaderView* subjectHeader;
@end

@implementation MessageDetailVC
// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupNavigationItems];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupNavigationItems {
    self.navigationItem.leftBarButtonItem = [self.splitViewController displayModeButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void) setupTableView {
    self.subjectHeader = (SubjectHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"SubjectHeaderView" owner:self options:nil] firstObject];
    self.subjectHeader.titleLabel.text = self.message.subject;
    self.tableView.tableHeaderView = self.subjectHeader;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setters & Getters

- (Message*) message {
    NSAssert(self.messageId != nil, @"MessageId mustn't be nil");
    
    if (_message == nil) {
        _message = [Message withCustomId:self.messageId fromContext:self.context];
    }
    
    return _message;
}




// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Dependencies

- (NSManagedObjectContext *) context {
    if (_context == nil) {
        // Dependency not set, use default context
        _context = [CoreDataStack sharedInstance].mainContext;
    }
    return _context;
}


@end
