//
//  InboxTableViewDataSourceTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 17/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "InboxTableViewDataSource.h"
#import "TestCoreDataStack.h"
#import "NSManagedObject+Helpers.h"
#import "Message.h"
#import "MessageListCell.h"

// Expose private functions needed for testing
@interface InboxTableViewDataSource (Private)
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end


SPEC_BEGIN(InboxTableViewDataSourceTests)

describe(@"InboxTableView", ^{
    
    __block InboxTableViewDataSource* dataSource;
    __block TestCoreDataStack* coreDataStack;
    __block UITableView* tableView;
    
    beforeEach(^{
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        coreDataStack = [TestCoreDataStack new];
        dataSource = [[InboxTableViewDataSource alloc] initWithTableView:tableView context:coreDataStack.mainContext];
    });
    
    context(@"when having 3 messages in the context", ^{
        beforeEach(^{
            Message* mIV = [Message findOrCreateElementWithId:@"Episode IV" context:coreDataStack.mainContext];
            Message* mV =  [Message findOrCreateElementWithId:@"Episode V" context:coreDataStack.mainContext];
            Message* mVI = [Message findOrCreateElementWithId:@"Episode VI" context:coreDataStack.mainContext];
            
            mIV.timestamp = 1977;
            mV.timestamp =  1980;
            mVI.timestamp = 1983;
        });
        
        it(@"should return 3 as a number of cells", ^{
            // Because update of NSFetchedResultsController is not synchronous,
            // we have to use async test here
            [[expectFutureValue(theValue([dataSource tableView:nil numberOfRowsInSection:0]))
              shouldEventually] equal: theValue(3)];
        });
        
        it(@"should return MessageListCells with correct data in ascending order by timestamp", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates
            
            MessageListCell* cellIV = (MessageListCell*)[dataSource tableView:tableView
                                                        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [[cellIV.timestampLabel.text should] equal:@"1977"];

            MessageListCell* cellV  = (MessageListCell*)[dataSource tableView:tableView
                                                        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [[cellV.timestampLabel.text should] equal:@"1980"];

            MessageListCell* cellVI = (MessageListCell*)[dataSource tableView:tableView
                                                        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            [[cellVI.timestampLabel.text should] equal:@"1983"];
        });
        
        it(@"should add row to tableView when new message is added", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates
            
            [Message findOrCreateElementWithId:@"Episode I" context:coreDataStack.mainContext];
            
            [[tableView shouldEventually] receive:@selector(beginUpdates)];
            [[tableView shouldEventually] receive:@selector(insertRowsAtIndexPaths:withRowAnimation:)];
            [[tableView shouldEventually] receive:@selector(endUpdates)];
        });

        it(@"should add row to tableView when new message is added", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates
            
            [Message findOrCreateElementWithId:@"Episode I" context:coreDataStack.mainContext];
            
            [[tableView shouldEventually] receive:@selector(beginUpdates)];
            [[tableView shouldEventually] receive:@selector(insertRowsAtIndexPaths:withRowAnimation:)];
            [[tableView shouldEventually] receive:@selector(endUpdates)];
        });
    });
});

SPEC_END