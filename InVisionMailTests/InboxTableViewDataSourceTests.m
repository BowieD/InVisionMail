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
#import "UITableViewCell+Helpers.h"

// Expose private functions needed for testing
@interface TableViewDataSource (Private)
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
@end


SPEC_BEGIN(InboxTableViewDataSourceTests)

describe(@"InboxTableView", ^{
    
    __block TableViewDataSource* dataSource;
    __block TestCoreDataStack* coreDataStack;
    __block UITableView* tableView;
    
    beforeEach(^{
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        coreDataStack = [TestCoreDataStack new];
        dataSource = [TableViewDataSource inboxTableViewDataSource:tableView context:coreDataStack.mainContext];
    });
    
    it(@"should insert new message when table is empty", ^{
        [coreDataStack.mainContext save:nil]; // finish pending updates
        [Message findOrCreateElementWithId:@"Episode IV" context:coreDataStack.mainContext];

        [[expectFutureValue(theValue(tableView.numberOfSections)) shouldEventually] equal:theValue(1)];
        [[expectFutureValue(theValue([tableView numberOfRowsInSection:0])) shouldEventually] equal:theValue(1)];
    });
    
    context(@"when having 3 messages in the context", ^{
        beforeEach(^{
            Message* mIV = [Message findOrCreateElementWithId:@"Episode IV" context:coreDataStack.mainContext];
            Message* mV =  [Message findOrCreateElementWithId:@"Episode V" context:coreDataStack.mainContext];
            Message* mVI = [Message findOrCreateElementWithId:@"Episode VI" context:coreDataStack.mainContext];
            
            mIV.timestamp = 233382025;
            mV.timestamp =  330335523;
            mVI.timestamp = 422745948;
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
            [[cellIV.timestampLabel.text should] equal:@"5/25/83"];

            MessageListCell* cellV  = (MessageListCell*)[dataSource tableView:tableView
                                                        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [[cellV.timestampLabel.text should] equal:@"6/20/80"];

            MessageListCell* cellVI = (MessageListCell*)[dataSource tableView:tableView
                                                        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            [[cellVI.timestampLabel.text should] equal:@"5/25/77"];
        });
        
        it(@"should add row to tableView when new message is added", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates
            
            [Message findOrCreateElementWithId:@"Episode I" context:coreDataStack.mainContext];
            
            [[tableView shouldEventually] receive:@selector(beginUpdates)];
            [[tableView shouldEventually] receive:@selector(insertRowsAtIndexPaths:withRowAnimation:)];
            [[tableView shouldEventually] receive:@selector(endUpdates)];
        });

        it(@"should update correct cell when message is updated", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates
            
            MessageListCell* cellVI = (MessageListCell*)[dataSource tableView:tableView
                                                        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

            [tableView stub:@selector(cellForRowAtIndexPath:) andReturn:cellVI];
            
            [[cellVI.subjectLabel.text should] beNil];
            
            Message* mIV = [Message withCustomId:@"Episode IV" fromContext:coreDataStack.mainContext];
            mIV.subject = @"Luke Skywalker joins forces with a Jedi Knight.";

            [[tableView shouldEventually] receive:@selector(beginUpdates)];
            [[tableView shouldEventually] receive:@selector(endUpdates)];
            
            [[expectFutureValue(cellVI.subjectLabel.text) shouldEventually] equal:@"Luke Skywalker joins forces with a Jedi Knight."];
        });
        
        it(@"shoul move cell when message order is changed", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates

            // Simulate that cell to move is visible so we can check it's updated
            MessageListCell* cell = (MessageListCell*)[[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:self options:nil] firstObject];
            [tableView stub:@selector(cellForRowAtIndexPath:) andReturn:cell];
            
            Message* mIV = [Message withCustomId:@"Episode IV" fromContext:coreDataStack.mainContext];
            mIV.timestamp = 347155200;

            [[tableView should] receive:@selector(beginUpdates)];
            [[tableView should] receive:@selector(endUpdates)];
            
            __block NSIndexPath* fromIndexPath;
            __block NSIndexPath* toIndexPath;
            
            [tableView stub:@selector(moveRowAtIndexPath:toIndexPath:) withBlock:^id(NSArray *params) {
                fromIndexPath = params[0];
                toIndexPath = params[1];
                return nil; // because of complier
            }];
            
            [[expectFutureValue(fromIndexPath) shouldEventually] equal:[NSIndexPath indexPathForRow:2 inSection:0]];
            [[expectFutureValue(toIndexPath) shouldEventually] equal:[NSIndexPath indexPathForRow:1 inSection:0]];
            [[expectFutureValue(cell.timestampLabel.text) shouldEventually] equal:@"1/1/81"];
        });
        
        it(@"should return 'nil' for section header view", ^{
            [[[dataSource tableView:tableView titleForHeaderInSection:0] should] beNil];
        });
    });
});

SPEC_END