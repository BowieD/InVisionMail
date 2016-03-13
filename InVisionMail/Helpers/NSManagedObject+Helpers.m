//
//  NSManagedObject+Helpers.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "NSManagedObject+Helpers.h"

@implementation NSManagedObject (Helpers)

+ (NSManagedObject*) findOrCreateElementWithName: (NSString *)name objectId:(NSString*) objectId context: (NSManagedObjectContext*)context {
    if (name == nil || objectId == nil) {
        return nil;
    }

    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:name];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId == '%@'" argumentArray:@[objectId]];

    NSError* error = nil;
    NSManagedObject* newObject = [[context executeFetchRequest:request error:&error] firstObject];
    
    if (error != nil) {
        // handle error
        return nil;
    } else if (newObject != nil) {
        return newObject;
    } else {
        return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
    }
}

@end
