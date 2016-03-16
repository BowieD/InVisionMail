//
//  InboxVCTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <Kiwi/Kiwi.h>
#import "InboxVC.h"
#import "APICommunicator.h"
#import "TestCoreDataStack.h"

@interface InboxVC (Private)
@property (nonatomic, weak) UITableView* tableView;
@end

SPEC_BEGIN(InboxVCTests)

describe(@"InboxVC", ^{
    __block InboxVC* inboxVC;
    __block CoreDataStack* testCoreDataStack;
    
    beforeEach(^{
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        inboxVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"InboxVC"];
        
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
        [[inboxVC.communicator should] receive:@selector(getMyMessagesToContext:)];
        [inboxVC beginAppearanceTransition:YES animated:NO];
    });
});

SPEC_END