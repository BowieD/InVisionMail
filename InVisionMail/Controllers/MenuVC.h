//
//  MenuVC.h
//  InVisionMail
//
//  Created by Vojta Stavik on 21/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APICommunicator.h"
#import "CoreDataStack.h"

@interface MenuVC : UIViewController

// Dependencies
@property (nonatomic, strong) APICommunicator* communicator;
@property (nonatomic, strong) NSManagedObjectContext* context;

@end
