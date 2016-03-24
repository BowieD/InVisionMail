//
//  MessageDetailVC.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MessageDetailVC.h"
#import "SubjectHeaderView.h"

@interface MessageDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SubjectHeaderView* subjectHeader;
@end

@implementation MessageDetailVC
// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];

    // test
    self.subjectHeader.titleLabel.text = self.messageId;
    
    self.navigationItem.leftBarButtonItem = [self.splitViewController displayModeButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupTableView {
    self.subjectHeader = (SubjectHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"SubjectHeaderView" owner:self options:nil] firstObject];
    self.tableView.tableHeaderView = self.subjectHeader;
}


@end
