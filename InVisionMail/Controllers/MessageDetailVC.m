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
#import "UITableViewCell+Helpers.h"
#import "MessageDetailPreviewCell.h"
#import "MessageDetailTableViewDataSource.h"

@interface MessageDetailVC () <UITableViewDelegate>

// This property is used just for getting 'threadId' and 'subject' for the thread
@property (nonatomic, strong) Message* message;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SubjectHeaderView* subjectHeader;

@property (nonatomic, strong) TableViewDataSource* dataSource;

@end



@implementation MessageDetailVC

// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Preferences

static CGFloat subjectHeaderHeight = 44;


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupNavigationItems];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self selectMessageWithId: self.messageId];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupNavigationItems {
    self.navigationItem.leftBarButtonItem = [self.splitViewController displayModeButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void) setupTableView {

    if (self.messageId == nil) {
        // We don't have message id (i.e. first start on iPad),
        // show just blank screen
        self.tableView.hidden = YES;
        return;
    }
    
    // Subject header
    self.subjectHeader = (SubjectHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"SubjectHeaderView" owner:self options:nil] firstObject];
    self.subjectHeader.titleLabel.text = self.message.subject;
    CGRect headerFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, subjectHeaderHeight);
    self.subjectHeader.frame = headerFrame;
    self.tableView.tableHeaderView = self.subjectHeader;
    
    // Datasource
    self.dataSource = [TableViewDataSource messageDetailTableViewDataSource:self.tableView threadId:self.message.threadId context:self.context];
    self.tableView.delegate = self;
    
    // Separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - API

- (void) getMessageDetailIfNeeded: (Message*) message {
    if (message != nil && message.body == nil) {
        [self.communicator getMessageDetail:message.customId toContext:self.context];
    }
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setters & Getters

- (Message*) message {
    if (_message == nil && _messageId != nil) {
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

- (APICommunicator *) communicator {
    if (_communicator == nil) {
        // Dependency not set, use default context
        _communicator = [APICommunicator sharedCommunicator];
    }
    return _communicator;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Helpers

- (void) selectMessageWithId: (NSString*) messageId {
    for (Message* message in self.dataSource.frc.fetchedObjects) {
        if ([message.customId isEqualToString:messageId]) {
            NSIndexPath* path = [self.dataSource.frc indexPathForObject:message];
            [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self tableView:self.tableView didSelectRowAtIndexPath:path];
            break;
        }
    }
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - TableView

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // load data from API if needed
    [self getMessageDetailIfNeeded: [self.dataSource.frc objectAtIndexPath:indexPath]];
    
    // Because the different appearance of closed/open cell is done just by autolayout,
    // the only thing we have to do here, is to refresh cell heights.
    [tableView beginUpdates];
    [tableView endUpdates];
    
    [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height;
    
    if ([indexPath isEqual:tableView.indexPathForSelectedRow]) {
        // Show full message, ask cell for the correct height
        height = [MessageDetailPreviewCell desiredHeightForWidth:tableView.frame.size.width
                                                       andData:[self.dataSource.frc objectAtIndexPath:indexPath]];
    } else {
        // Show just preview
        height = [MessageDetailPreviewCell previewHeight];
    }

    return height;
}

@end
