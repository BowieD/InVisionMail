//
//  MessageDetailTableViewDataSourceTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "MessageDetailTableViewDataSource.h"
#import "TestCoreDataStack.h"
#import "Message.h"
#import "NSManagedObject+Helpers.h"
#import "MessageDetailPreviewCell.h"

// Expose private functions needed for testing
@interface TableViewDataSource (Private)
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
@end


SPEC_BEGIN(MessageDetailTableViewDataSourceTests)

describe(@"MessageDetailTableViewDataSource", ^{

    __block TableViewDataSource* dataSource;
    __block TestCoreDataStack* coreDataStack;
    __block UITableView* tableView;
    
    beforeEach(^{
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        coreDataStack = [TestCoreDataStack new];
        dataSource = [TableViewDataSource messageDetailTableViewDataSource:tableView threadId:@"Original trilogy" context:coreDataStack.mainContext];
    });
    
    context(@"when having 2 messages for 'Original trilogy' thread", ^{
        beforeEach(^{
            Message* mIV = [Message findOrCreateElementWithId:@"Episode IV" context:coreDataStack.mainContext];
            mIV.snippet = @"A New Hope";
            mIV.threadId = @"Original trilogy";
            mIV.timestamp = 1977;

            Message* mV =  [Message findOrCreateElementWithId:@"Episode V" context:coreDataStack.mainContext];
            mV.snippet = @"The Empire Strikes Back";
            mV.threadId = @"Original trilogy";
            mV.timestamp = 1980;
            
            // Message from another thread
            Message* mI =  [Message findOrCreateElementWithId:@"Episode I" context:coreDataStack.mainContext];
            mI.threadId = @"Prequel trilogy";
        });
        
        it(@"number of sections should be 1", ^{
            [[expectFutureValue(theValue([dataSource numberOfSectionsInTableView:tableView]))
              shouldEventually] equal: theValue(1)];
        });

        it(@"number of rows in section 0 should be 2", ^{
            [[expectFutureValue(theValue([dataSource tableView:tableView numberOfRowsInSection:0]))
              shouldEventually] equal: theValue(2)];
        });
        
        it(@"should have newer messages ordered before older messages", ^{
            [coreDataStack.mainContext save:nil]; // apply pending changes
            
            MessageDetailPreviewCell* cell1 = (MessageDetailPreviewCell*)[dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            MessageDetailPreviewCell* cell2 = (MessageDetailPreviewCell*)[dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            
            [[cell1.snippetTextView.text should] equal:@"The Empire Strikes Back"];
            [[cell2.snippetTextView.text should] equal:@"A New Hope"];
        });
        
        it(@"should add row to tableView when new message is added", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates
            
            Message* mVI =  [Message findOrCreateElementWithId:@"Episode VI" context:coreDataStack.mainContext];
            mVI.snippet = @"Return of the Jedi";
            mVI.threadId = @"Original trilogy";
            mVI.timestamp = 1983;

            [[tableView shouldEventually] receive:@selector(beginUpdates)];
            [[tableView shouldEventually] receive:@selector(insertRowsAtIndexPaths:withRowAnimation:)];
            [[tableView shouldEventually] receive:@selector(endUpdates)];
        });

        it(@"should update correct cell when message is updated", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates

            Message* mIV = [Message withCustomId:@"Episode IV" fromContext:coreDataStack.mainContext];
            mIV.snippet = @"Star Wars: A New Hope";

            [[tableView shouldEventually] receive:@selector(beginUpdates)];
            [[tableView shouldEventually] receive:@selector(reloadRowsAtIndexPaths:withRowAnimation:)
                                    withArguments:@[[NSIndexPath indexPathForRow:1 inSection:0]], theValue(UITableViewRowAnimationAutomatic)];
            [[tableView shouldEventually] receive:@selector(endUpdates)];
        });
    });
});

SPEC_END