//
//  NSManagedObjectContext+BackgroundFetch.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 15/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "NSManagedObjectContext+PKEBackgroundFetch.h"

@implementation NSManagedObjectContext (PKEBackgroundFetch)

- (void)PKE_executeFetchRequest:(NSFetchRequest *)request
                     completion:(ArrayCompletionBlock)completion
{
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [backgroundContext performBlock:^{
        backgroundContext.persistentStoreCoordinator = coordinator;
        NSError *error = nil;
        NSArray *fetchedObjects = [backgroundContext executeFetchRequest:request error:&error];
        [self performBlock:^{
            if (fetchedObjects) {
                NSMutableArray *mutObjectIds = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]];
                for (NSManagedObject *obj in fetchedObjects) {
                    [mutObjectIds addObject:obj.objectID];
                }
                NSMutableArray *mutObjects = [[NSMutableArray alloc] initWithCapacity:[mutObjectIds count]];
                for (NSManagedObjectID *objectID in mutObjectIds) {
                    NSManagedObject *obj = [self objectWithID:objectID];
                    [mutObjects addObject:obj];
                }
                if (completion) {
                    NSArray *objects = [mutObjects copy];
                    completion(objects, nil);
                }
            } else {
                if (completion) {
                    completion(nil, error);
                }
            }
        }];
    }];
}

@end
