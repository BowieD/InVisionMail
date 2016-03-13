//
//  CoreDataStack.m
//  InVisionMail
//
//  Created by Vojta Stavik on 13/03/16.
//  Copyright © 2016 Vojta Stavik. All rights reserved.
//

#import "CoreDataStack.h"

@implementation CoreDataStack

+ (CoreDataStack *) sharedInstance {
    static CoreDataStack *sharedStack = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedStack = [[self alloc] init];
    });
    
    return sharedStack;
}

- (instancetype) init {
    if (self = [super init]) {
        [self prepareCoreDataStack];
    }
    return self;
}

- (void)prepareCoreDataStack {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"InVisionMail" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    self.mainContext = moc;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"InVisionMail"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        // We will use InMemoryStore during the heavy development
        NSPersistentStore *store = [moc.persistentStoreCoordinator
                                        addPersistentStoreWithType:NSInMemoryStoreType
                                        configuration:nil
                                        URL:storeURL
                                        options:nil
                                        error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}

@end
