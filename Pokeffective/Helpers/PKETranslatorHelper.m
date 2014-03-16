//
//  PKETranslatorHelper.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKETranslatorHelper.h"

@implementation PKETranslatorHelper

- (id)translateModelfromManagedObject:(NSManagedObject *)managedObject
                            withClass:(Class)objectClass
{
    NSParameterAssert(objectClass != nil);
    NSError *error = nil;
    id model = [MTLManagedObjectAdapter modelOfClass:objectClass
                                   fromManagedObject:managedObject
                                               error:&error];
    if (!error) {
        return model;
    } else {
        return nil;
    }
}

- (id)translateCollectionfromManagedObjects:(NSArray *)managedObjects
                                  withClass:(Class)objectClass;
{
    NSParameterAssert(objectClass != nil);
    if ([managedObjects isKindOfClass:[NSArray class]]) {
        NSMutableArray *collection = [NSMutableArray array];
        for (NSManagedObject *managedObject in managedObjects) {
            id model = [self translateModelfromManagedObject:managedObject
                                               withClass:objectClass];
            [collection addObject:model];
        }
        return collection;
    }
    return nil;
}

@end
