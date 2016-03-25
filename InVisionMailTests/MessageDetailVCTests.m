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
#import "APICommunicator.h"
#import "MessageDetailPreviewCell.h"
#import "TableViewDataSource.h"

// Expose private properties and functions needed for testing
@interface MessageDetailVC (Private)

@property (nonatomic, strong) Message* message;

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) SubjectHeaderView* subjectHeader;
@property (nonatomic, strong) TableViewDataSource* dataSource;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

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
        viewController.communicator = [APICommunicator mock];

        // Message
        message = [Message findOrCreateElementWithId:@"Episode IV" context:coreDataStack.mainContext];
        message.subject = @"Luke Skywalker joins forces with a Jedi Knight.";
        message.snippet = @"Luke, you can destroy the Emperor. He has foreseen this.";
        [coreDataStack.mainContext save:nil]; // Apply pending changes
        
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
    
    // ------------  ------------  ------------  ------------  ------------  ------------
    // API

    it(@"should select intial message", ^{
        [[viewController.communicator should] receive:@selector(getMessageDetail:toContext:) withArguments:@"Episode IV", coreDataStack.mainContext];

        [viewController beginAppearanceTransition:YES animated:NO];
        [[viewController.tableView.indexPathForSelectedRow should] equal:[NSIndexPath indexPathForRow:0 inSection:0]];
    });
    
    it(@"should ask APICommunicator to get message detail of selected message if body is empty", ^{
        message.body = nil;
        
        [[viewController.communicator should] receive:@selector(getMessageDetail:toContext:) withArguments:@"Episode IV", coreDataStack.mainContext];

        NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
        [viewController.tableView selectRowAtIndexPath:path
                                              animated:NO scrollPosition:0];
        [viewController tableView:viewController.tableView didSelectRowAtIndexPath:path];
    });
    
    
    // ------------  ------------  ------------  ------------  ------------  ------------
    // TableView
    
    describe(@"table view", ^{
        __block UITableView* tableView;
        
        beforeEach(^{
            tableView = viewController.tableView;
        });
        
        it(@"should be initialized", ^{
            [tableView shouldNotBeNil];
        });
        
        it(@"should have viewController as delegate", ^{
            [[viewController should] beIdenticalTo:tableView.delegate];
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
        
        describe(@"delegate", ^{
            beforeEach(^{
                [tableView stub:@selector(indexPathForSelectedRow) andReturn:[NSIndexPath indexPathForRow:0 inSection:0]];
            });
            
            it(@"should return height previewHeight for unselected cell - row:1 section:0", ^{
                CGFloat height = [tableView.delegate tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                
                [[theValue(height) should] equal:theValue([MessageDetailPreviewCell previewHeight])];
            });

            it(@"should return cell's desired height selected cell - row:0 section:0", ^{
                [MessageDetailPreviewCell stub:@selector(desiredHeightForWidth:andData:) andReturn:theValue(500)];
                
                CGFloat height = [tableView.delegate tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                
                [[theValue(height) should] equal:theValue(500)];
            });
            
            it(@"should send correct width and object to cell prototype while asking for desired height", ^{
                [[[MessageDetailPreviewCell class] should] receive:@selector(desiredHeightForWidth:andData:) withArguments:theValue(tableView.frame.size.width), message];
                
                [tableView.delegate tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            });
            
            afterEach(^{
                [[MessageDetailPreviewCell class] clearStubs];
            });
        });
        
        describe(@"data source", ^{
           it(@"should be MessageDetailTableViewDataSource", ^{
               [[viewController.dataSource should] beIdenticalTo: tableView.dataSource];
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