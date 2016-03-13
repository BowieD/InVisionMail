//
//  NSManagedObject+Helpers.h
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helpers)

+ (NSString*) entityName;
+ (NSManagedObject*) findOrCreateElementWithName: (NSString *)name objectId:(NSString*) objectId context: (NSManagedObjectContext*)context;

@end
