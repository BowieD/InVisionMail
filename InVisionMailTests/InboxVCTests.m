//
//  InboxVCTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

// We can ignore warning about potential leaking selectors for unit tests
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <Kiwi/Kiwi.h>
#import "InboxVC.h"
#import "APICommunicator.h"
#import "TestCoreDataStack.h"
#import "InboxTableViewDataSource.h"
#import "DrawerVC.h"
#import "Message.h"
#import "NSManagedObject+Helpers.h"
#import "MessageDetailVC.h"
#import "Segues.h"

// Expose private properties and functions needed for testing
@interface InboxVC (Private)
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) TableViewDataSource* dataSource;
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

SPEC_BEGIN(InboxVCTests)

describe(@"InboxVC", ^{
    __block InboxVC* inboxVC;
    __block CoreDataStack* testCoreDataStack;
    
    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController* navCon = [mainStoryboard instantiateViewControllerWithIdentifier:@"InboxVCNavigationController"];
        inboxVC = [navCon.viewControllers firstObject];
        
        // Set dependencies
        testCoreDataStack = [TestCoreDataStack new];
        inboxVC.context = testCoreDataStack.mainContext;
        inboxVC.communicator = [APICommunicator mock];
        
        UIView* view __unused = inboxVC.view; // load view
    });
    
   it(@"should have a title Inbox", ^{
       [[inboxVC.title should] equal:@"Inbox"];
   });
    
    it(@"should have table view initialized", ^{
        [inboxVC.tableView shouldNotBeNil];
    });
    
    it(@"should ask APICommunicator to update inbox messages when view appears", ^{
        [[inboxVC.communicator should] receive:@selector(getMyMessagesToContext:completion:)];
        [inboxVC beginAppearanceTransition:YES animated:NO];
    });


    describe(@"Left bar button item", ^{
        __block UIBarButtonItem* hamburger;
        
        beforeEach(^{
            hamburger = inboxVC.navigationItem.leftBarButtonItem;
        });
        
        it(@"should have the Hamburger icon", ^{
            [[hamburger.image should] equal:[UIImage imageNamed:@"hamburger-icon"]];
        });
        
        it(@"should open drawer when pressed", ^{
            DrawerVC* drawer = [KWMock mockForClass:[DrawerVC class]];
            [inboxVC stub:@selector(drawerVC) andReturn:drawer];
            
            [[drawer should] receive:@selector(showMenu)];
            [hamburger.target performSelector:hamburger.action withObject:hamburger];
        });
    });
    
    describe(@"tableView", ^{
        it(@"should have InboxTableViewDatasource as a datasource", ^{
            [[inboxVC.dataSource should] beIdenticalTo:inboxVC.tableView.dataSource];
        });
        
        it(@"should have row hight 80", ^{
            [[theValue(inboxVC.tableView.rowHeight) should] equal:theValue(80)];
        });
    });
    
    it(@"shoud show message detail when message is selected", ^{
        // Create dummy message
        [Message findOrCreateElementWithId:@"Episode IV" context:testCoreDataStack.mainContext];
        [testCoreDataStack.mainContext save:nil];

        __block UIViewController* destinationVC = nil;
        [inboxVC stub:@selector(prepareForSegue:sender:) withBlock:^id(NSArray *params) {

            UIStoryboardSegue* segue = (UIStoryboardSegue*)params[0];
            UINavigationController* nav = segue.destinationViewController;
            destinationVC = nav.viewControllers.firstObject;
            return nil; // because of compiler
        }];
        
        [inboxVC tableView:inboxVC.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [[expectFutureValue(theValue([destinationVC isKindOfClass:[MessageDetailVC class]])) shouldEventually] beTrue];
    });
    
    it(@"should set selected message id to MessageDetailVC", ^{
        // Create dummy message
        [Message findOrCreateElementWithId:@"Episode IV" context:testCoreDataStack.mainContext];
        [testCoreDataStack.mainContext save:nil];
        [inboxVC.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        UIStoryboardSegue* segue = [[UIStoryboardSegue alloc] initWithIdentifier:SHOW_MESSAGE_DETAIL source:inboxVC destination:[[UINavigationController alloc] initWithRootViewController:[MessageDetailVC new]]];
        
        [inboxVC prepareForSegue:segue sender:nil];
        
        MessageDetailVC* detailVC = ((UINavigationController *)segue.destinationViewController).viewControllers.firstObject;
        [[detailVC.messageId should] equal: @"Episode IV"];
    });
});

SPEC_END
