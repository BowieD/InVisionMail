//
//  MenuTableViewDataSourceTests.m
//  InVisionMail
//
//  Created by Vojta Stavik on 22/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "MenuTableViewDatasource.h"
#import "MenuCell.h"
#import "TestCoreDataStack.h"
#import "Label.h"
#import "NSManagedObject+Helpers.h"

// Expose private functions needed for testing
@interface TableViewDataSource (Private)
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
@end

// Expose private functions needed for testing
@interface MenuCell (Private)
@property (nonatomic, weak) UILabel* titleLabel;
@end



SPEC_BEGIN(MenuTableViewDataSourceTests)

describe(@"InboxTableView", ^{
    
    __block TableViewDataSource* dataSource;
    __block TestCoreDataStack* coreDataStack;
    __block UITableView* tableView;
    
    beforeEach(^{
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        coreDataStack = [TestCoreDataStack new];
        dataSource = [TableViewDataSource menuTableViewDataSource:tableView context:coreDataStack.mainContext];
    });
    
    context(@"when having Labels with Mailobox and Categories categories", ^{
        beforeEach(^{
            Label* lIV = [Label findOrCreateElementWithId:@"1 - Episode IV" context:coreDataStack.mainContext];
            lIV.title = @"A New Hope";
            lIV.category = MAILBOXES_CATEGORY;
            
            Label* lV =  [Label findOrCreateElementWithId:@"5 - Episode V" context:coreDataStack.mainContext];
            lV.title =  @"The Empire Strikes Back";
            lV.category = GROUPS_CATEGORY;
        });
        
        it(@"should return 2 as a number of sections", ^{
            // Because update of NSFetchedResultsController is not synchronous,
            // we have to use async test here
            [[expectFutureValue(theValue([dataSource numberOfSectionsInTableView:tableView]))
              shouldEventually] equal: theValue(2)];
        });
        
        
        it(@"should return 'Mailboxes' and 'Groups' for section header 1 & 2", ^{
            [coreDataStack.mainContext save:nil]; // apply pending updates
            
            [[[[dataSource tableView:tableView titleForHeaderInSection:0] capitalizedString] should] equal:[@"Mailboxes" capitalizedString]];
            [[[[dataSource tableView:tableView titleForHeaderInSection:1] capitalizedString] should] equal:[@"Groups" capitalizedString]];
        });
    });
    
    context(@"when having 3 messages for each category in the context", ^{
        beforeEach(^{
            Label* lIV = [Label findOrCreateElementWithId:@"1 - Episode IV" context:coreDataStack.mainContext];
            lIV.title = @"A New Hope";
            lIV.category = MAILBOXES_CATEGORY;
            
            Label* lV =  [Label findOrCreateElementWithId:@"5 - Episode V" context:coreDataStack.mainContext];
            lV.title =  @"The Empire Strikes Back";
            lV.category = MAILBOXES_CATEGORY;
            
            Label* lVI = [Label findOrCreateElementWithId:@"9 - Episode VI" context:coreDataStack.mainContext];
            lVI.title = @"Return of the Jedi";
            lVI.category = MAILBOXES_CATEGORY;
            
            Label* lI = [Label findOrCreateElementWithId:@"CATEGORY 1 - Episode I" context:coreDataStack.mainContext];
            lI.title = @"The Phantom Menace";
            lI.category = GROUPS_CATEGORY;
            
            Label* lII =  [Label findOrCreateElementWithId:@"CATEGORY 5 - Episode II" context:coreDataStack.mainContext];
            lII.title =  @"Attack of the Clones";
            lII.category = GROUPS_CATEGORY;
            
            Label* lIII = [Label findOrCreateElementWithId:@"CATEGORY 9 - Episode III" context:coreDataStack.mainContext];
            lIII.title = @"Revenge of the Sith";
            lIII.category = GROUPS_CATEGORY;
        });
        
        it(@"should return 3 as a number of cells in sections 1 & 2", ^{
            // Because update of NSFetchedResultsController is not synchronous,
            // we have to use async test here
            [[expectFutureValue(theValue([dataSource tableView:tableView numberOfRowsInSection:0]))
              shouldEventually] equal: theValue(3)];

            [[expectFutureValue(theValue([dataSource tableView:tableView numberOfRowsInSection:1]))
              shouldEventually] equal: theValue(3)];
        });

        it(@"should show 'Mailbox' category before 'Categories'", ^{
            [coreDataStack.mainContext save:nil]; // finish pending updates

            MenuCell* cellIV = (MenuCell*)[dataSource tableView:tableView
                                          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [[cellIV.titleLabel.text should] equal:@"A New Hope"];

            MenuCell* cellI = (MenuCell*)[dataSource tableView:tableView
                                          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            [[cellI.titleLabel.text should] equal:@"The Phantom Menace"];
        });
        
        it(@"should return MenuCell with correct data in order by 'order' and 'customId'", ^{
            [Label findOrCreateElementWithId:@"9 - Episode VI" context:coreDataStack.mainContext].order = 1;
            [Label findOrCreateElementWithId:@"1 - Episode IV" context:coreDataStack.mainContext].order = 2;
            [Label findOrCreateElementWithId:@"5 - Episode V" context:coreDataStack.mainContext].order  = 2;
            
            [coreDataStack.mainContext save:nil]; // Finish all pending updates
            
            MenuCell* cellIV = (MenuCell*)[dataSource tableView:tableView
                                          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [[cellIV.titleLabel.text should] equal:@"Return Of The Jedi"];
            
            MenuCell* cellV  = (MenuCell*)[dataSource tableView:tableView
                                          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [[cellV.titleLabel.text should] equal:@"A New Hope"];
            
            MenuCell* cellVI = (MenuCell*)[dataSource tableView:tableView
                                          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            [[cellVI.titleLabel.text should] equal:@"The Empire Strikes Back"];
        });
        
        it(@"should add row to tableView when new message is added", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates
            Label* lVII = [Label findOrCreateElementWithId:@"16 - Episode VII" context:coreDataStack.mainContext];
            lVII.category = MAILBOXES_CATEGORY;
            
            [[tableView shouldEventually] receive:@selector(beginUpdates)];
            [[tableView shouldEventually] receive:@selector(insertRowsAtIndexPaths:withRowAnimation:)];
            [[tableView shouldEventually] receive:@selector(endUpdates)];
        });
        
        it(@"should update correct cell when message is updated", ^{
            [coreDataStack.mainContext save:nil]; // Finish all pending updates
            
            MenuCell* cell = (MenuCell*)[dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            [[cell.titleLabel.text should] equal:@"A New Hope"];
            [tableView stub:@selector(cellForRowAtIndexPath:) andReturn:cell];

            Label* lIV = [Label withCustomId:@"1 - Episode IV" fromContext:coreDataStack.mainContext];
            lIV.title = @"Star Wars: A New Hope";
            
            [[tableView shouldEventually] receive:@selector(beginUpdates)];
            [[tableView shouldEventually] receive:@selector(endUpdates)];
            [[expectFutureValue(cell.titleLabel.text)shouldEventually] equal:@"Star Wars: A New Hope"];
        });
        
        it(@"shoul move cell when message order is changed", ^{
            [Label findOrCreateElementWithId:@"9 - Episode VI" context:coreDataStack.mainContext].order = 1;
            [Label findOrCreateElementWithId:@"5 - Episode V" context:coreDataStack.mainContext].order  = 5;
            [Label findOrCreateElementWithId:@"1 - Episode IV" context:coreDataStack.mainContext].order = 10;
            
            [coreDataStack.mainContext save:nil]; // Apply changes

            // Simulate that cell to move is visible so we can check it's updated
            MenuCell* cell = (MenuCell*)[[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] firstObject];
            [tableView stub:@selector(cellForRowAtIndexPath:) andReturn:cell];
            
            [Label findOrCreateElementWithId:@"1 - Episode IV" context:coreDataStack.mainContext].order = 4;
            
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
        });
    });
});

SPEC_END