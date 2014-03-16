//
//  PKETranslatorHelper.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKETranslatorHelper : NSObject

- (id)translateModelfromManagedObject:(NSManagedObject *)managedObject
                            withClass:(Class)objectClass;
- (id)translateCollectionfromManagedObjects:(NSArray *)managedObjects
                              withClass:(Class)objectClass;

@end
