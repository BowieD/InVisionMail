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

+ (instancetype) findOrCreateElementWithId: (NSString*) customId context: (NSManagedObjectContext*)context {
    NSString* name = [self entityName];
    if (name == nil || customId == nil) {
        return nil;
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:name];
    request.predicate = [NSPredicate predicateWithFormat:@"customId == %@" argumentArray:@[customId]];

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
            loadableObject.customId = customId;
        }
        
        return newObject;
    }
}

+ (void) loadFromJSON: (NSDictionary* _Nullable)JSONData
                       customId:(NSString* _Nonnull) objectId
                        context: (NSManagedObjectContext* _Nonnull)context
                completionBlock: (nullable void (^)(NSManagedObject * _Nullable element))completion {
    
    NSManagedObject* element = [self findOrCreateElementWithId:objectId context:context];
    if (element == nil) {
        NSLog(@"Can't create element.");
        completion(nil);
        return;
    }
    
    if ([element conformsToProtocol:@protocol(JSONLoadable)]) {
        NSManagedObject <JSONLoadable> * loadableObject = (NSManagedObject <JSONLoadable> *) element;

        [context performBlock:^{
            [loadableObject loadData:JSONData];

            NSError* error = nil;
            [context save:&error];
            
            if (error != nil) {
                NSLog(@"Error while saving context.");
                completion(nil);
                return;
            }
            
            if (completion != nil) {
                completion(loadableObject);
            }
        }];
    }
}

+ (nullable instancetype) withCustomId: (NSString* _Nonnull)customId fromContext: (NSManagedObjectContext* _Nonnull)context {
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"customId == %@" argumentArray:@[customId]];
    
    NSError* error = nil;
    NSManagedObject* fetchedObject = [[context executeFetchRequest:request error:&error] firstObject];
    return fetchedObject;
}

@end
