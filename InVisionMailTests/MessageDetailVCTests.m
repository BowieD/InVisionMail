//
//  MessageDetailVCTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "MessageDetailVC.h"
#import "TestCoreDataStack.h"
#import "Message.h"
#import "NSManagedObject+Helpers.h"
#import "SubjectHeaderView.h"

// Expose private properties and functions needed for testing
@interface MessageDetailVC (Private)
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, weak) SubjectHeaderView* subjectHeader;
@end


SPEC_BEGIN(MessageDetailVCTests)

describe(@"MessageDetailVC", ^{
    
    __block MessageDetailVC* viewController;
    __block TestCoreDataStack* coreDataStack;
    
    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MessageDetailVC"];
        
        // Set dependencies
        coreDataStack = [TestCoreDataStack new];
//        inboxVC.context = testCoreDataStack.mainContext;
//        inboxVC.communicator = [APICommunicator mock];
        
        UIView* view __unused = viewController.view; // load view
    });
    
    describe(@"table view", ^{
        __block UITableView* tableView;
        
        beforeEach(^{
            tableView = viewController.tableView;
        });
        
        it(@"should be initialized", ^{
            [tableView shouldNotBeNil];
        });

        it(@"should have SubjectHeader with message Subject as the table header view", ^{
            [[tableView.tableHeaderView should] beKindOfClass:[SubjectHeaderView class]];
            [[tableView.tableHeaderView should] beIdenticalTo:viewController.subjectHeader];
        });

    });
    
    
});

SPEC_END