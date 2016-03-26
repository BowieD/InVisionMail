//
//  MenuVCTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "MenuVC.h"
#import "TestCoreDataStack.h"
#import "TableViewDataSource.h"

// Expose private properties and functions needed for testing
@interface MenuVC (Private)
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) TableViewDataSource* dataSource;
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end


SPEC_BEGIN(MenuVCTests)

describe(@"MenuVC", ^{
    __block MenuVC* menuVC;
    __block CoreDataStack* testCoreDataStack;
    
    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        menuVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"MenuVC"];
        
        // Set dependencies
        testCoreDataStack = [TestCoreDataStack new];
        menuVC.context = testCoreDataStack.mainContext;
        menuVC.communicator = [APICommunicator mock];
        
        UIView* view __unused = menuVC.view; // load view
    });
    
    it(@"should have table view initialized", ^{
        [menuVC.tableView shouldNotBeNil];
    });
    
    it(@"should ask APICommunicator to update Labels when view will appear", ^{
        [[menuVC.communicator should] receive:@selector(getMyLabelsToContext:)];
        [menuVC beginAppearanceTransition:YES animated:NO];
    });
    
    describe(@"tableView", ^{
        it(@"should have InboxTableViewDatasource as a datasource", ^{
            [[menuVC.dataSource should] beIdenticalTo:menuVC.tableView.dataSource];
        });
        
        it(@"should have row hight 44", ^{
            [[theValue(menuVC.tableView.rowHeight) should] equal:theValue(44)];
        });
    });
    
});

SPEC_END
