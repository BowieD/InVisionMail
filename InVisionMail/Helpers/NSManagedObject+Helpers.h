//
//  NSManagedObject+Helpers.h
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helpers)

/**
 Returns entity name derived from its class name.
*/
+ (nonnull NSString*) entityName;

/**
 Creates entity in the context and assing customId to it. Entity has to conform to JSONLoadable procotol. If the entity with the customId already exists in the context, it will return the existing one.
 */
+ (nullable instancetype) findOrCreateElementWithId: (NSString* _Nonnull) customId context: (NSManagedObjectContext* _Nonnull)context;

/**
 This function will create the element (or find it, if already exists) and load data into it from the JSONData dictionary. It uses JSONLoadable protocol for it.
*/
+ (void) loadFromJSON: (NSDictionary* _Nullable)JSONData customId:(NSString* _Nonnull) objectId
                                                  context: (NSManagedObjectContext* _Nonnull)context
                                          completionBlock: (nullable void (^)(NSManagedObject * _Nullable element))completion;

/**
 Returns entity with certain customId. If entity doesn't exists, returns nil.
 */
+ (nullable instancetype) withCustomId: (NSString* _Nonnull)customId fromContext: (NSManagedObjectContext* _Nonnull)context;

@end
