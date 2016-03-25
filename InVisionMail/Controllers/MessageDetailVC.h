//
//  MessageDetailVC.h
//  InVisionMail
//
//  Created by Vojta Stavik on 23/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APICommunicator.h"

@interface MessageDetailVC : UIViewController

@property (nonnull, nonatomic, strong) NSString* messageId;

// Dependencies
@property (nullable, nonatomic, strong) APICommunicator* communicator;
@property (nullable, nonatomic, strong) NSManagedObjectContext* context;


@end
