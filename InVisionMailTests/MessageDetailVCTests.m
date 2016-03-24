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
@property (nonatomic, strong) Message* message;
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) SubjectHeaderView* subjectHeader;
@end


SPEC_BEGIN(MessageDetailVCTests)

describe(@"MessageDetailVC", ^{
    
    __block MessageDetailVC* viewController;
    __block TestCoreDataStack* coreDataStack;
    __block Message* message;

    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MessageDetailVC"];

        // Set dependencies
        coreDataStack = [TestCoreDataStack new];
        viewController.context = coreDataStack.mainContext;
//        inboxVC.communicator = [APICommunicator mock];

        // Message
        message = [Message findOrCreateElementWithId:@"Episode IV" context:coreDataStack.mainContext];
        message.subject = @"Luke Skywalker joins forces with a Jedi Knight.";
        viewController.messageId = @"Episode IV";
        
        UIView* view __unused = viewController.view; // load view
    });
    
    describe(@"navigation item", ^{
        __block UISplitViewController* splitVC;
        
        beforeEach(^{
            splitVC = [UISplitViewController new];
            [viewController stub:@selector(splitViewController) andReturn:splitVC];
            
            // reload view manually to update splitVC reletad values
            [viewController viewDidLoad];
        });
        
        it(@"show have set leftItemsSupplementBackButton to Yes", ^{
            [[theValue(viewController.navigationItem.leftItemsSupplementBackButton) should] beTrue];
        });
        
        it(@"show have set leftBarButtonItem to splitViewController displayModeButtonItem", ^{
            UIBarButtonItem* displayMode = [splitVC displayModeButtonItem];
            [[viewController.navigationItem.leftBarButtonItem should] equal:displayMode];
        });
    });
    
    describe(@"table view", ^{
        __block UITableView* tableView;
        
        beforeEach(^{
            tableView = viewController.tableView;
        });
        
        it(@"should be initialized", ^{
            [tableView shouldNotBeNil];
        });

        describe(@"subject header", ^{
            __block SubjectHeaderView* header;
            
            beforeEach(^{
                header = viewController.subjectHeader;
            });
            
            it(@"should be used as tableView header", ^{
                [[tableView.tableHeaderView should] beKindOfClass:[SubjectHeaderView class]];
                [[tableView.tableHeaderView should] beIdenticalTo:viewController.subjectHeader];
            });
            
            it(@"should have title 'Luke Skywalker joins forces with a Jedi Knight'", ^{
                [[header.titleLabel.text should] equal:@"Luke Skywalker joins forces with a Jedi Knight."];
            });
        });
        

    });
    
    describe(@"message", ^{
        it(@"should be loaded by given customId", ^{
            [[viewController.message should] beIdenticalTo:message];
        });
    });
    
});

SPEC_END