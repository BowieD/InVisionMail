//
//  NSManagedObject+Helpers.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "NSManagedObject+Helpers.h"
#import "JSONLoadable.h"

@implementation NSManagedObject (Helpers)

+ (NSString*) entityName {
    return NSStringFromClass([self class]);
}

+ (instancetype) findOrCreateElementWithId: (NSString*) objectId context: (NSManagedObjectContext*)context {
    NSString* name = [self entityName];
    if (name == nil || objectId == nil) {
        return nil;
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:name];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId == '%@'" argumentArray:@[objectId]];

    NSError* error = nil;
    NSManagedObject* fetchedObject = [[context executeFetchRequest:request error:&error] firstObject];
    
    if (error != nil) {
        // handle error
        return nil;
    } else if (fetchedObject != nil) {
        return fetchedObject;
    } else {
        NSManagedObject* newObject = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];

        // if newObject conforms to JSONLoadable, we should assign customId to it
        if ([newObject conformsToProtocol:@protocol(JSONLoadable)]) {
            NSManagedObject <JSONLoadable> * loadableObject = (NSManagedObject <JSONLoadable> *) newObject;
            loadableObject.customId = objectId;
        }
        
        return newObject;
    }
}

@end
