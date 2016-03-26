//
//  MenuVC.m
//  InVisionMail
//
//  Created by Vojta Stavik on 21/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "MenuVC.h"
#import "MenuTableViewDatasource.h"
#import "UIColor+AppColors.h"
#import "MenuSectionHeader.h"

@interface MenuVC () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TableViewDataSource* dataSource;
@end


@implementation MenuVC
// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Preferences

static CGFloat rowHeight = 44;


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableViewAndDatasource];
    [self setupAppearance];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.communicator getMyLabelsToContext:self.context];
}


// ------------  ------------  ------------  ------------  ------------  ------------
#pragma mark - Setup

- (void) setupTableViewAndDatasource {
    [self.tableView registerNib:[MenuSectionHeader nib] forHeaderFooterViewReuseIdentifier:[MenuSectionHeader reuseIdentifier]];
    
    self.dataSource = [TableViewDataSource menuTableViewDataSource:self.tableView context:self.context];
    
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = rowHeight;
}

- (void) setupAppearance {
    self.view.backgroundColor = [UIColor invision_drawerBackgroundColor];
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

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // We provide custom selection style at the cell level
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Change the inboxVC feed
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MenuSectionHeader* header = (MenuSectionHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[MenuSectionHeader reuseIdentifier]];
    [header setTitle:self.dataSource.frc.sections[section].name];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // To make visual spacing between section
    return rowHeight / 2;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // We just return transluent view
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
