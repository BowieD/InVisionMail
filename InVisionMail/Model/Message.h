//
//  Message.h
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "JSONLoadable.h"

@interface Message : NSManagedObject <JSONLoadable>

@property (nonatomic) NSTimeInterval timestamp;

@property (nullable, nonatomic, copy) NSString *customId;
@property (nullable, nonatomic, retain) NSString *threadId;
@property (nullable, nonatomic, retain) NSString *historyId;
@property (nullable, nonatomic, retain) NSString *snippet;

@end
