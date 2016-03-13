//
//  Message+CoreDataProperties.h
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nonatomic) NSTimeInterval timestamp;
@property (nullable, nonatomic, retain) NSString *objectId;
@property (nullable, nonatomic, retain) NSString *threadId;

@end

NS_ASSUME_NONNULL_END
