//
//  PKEPokemonManagedObject.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PKEPokemonManagedObject : NSManagedObject

@property (nonatomic, retain) NSNumber * firstType;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * secondType;
@property (nonatomic, retain) NSSet *moves;
@end

@interface PKEPokemonManagedObject (CoreDataGeneratedAccessors)

- (void)addMovesObject:(NSManagedObject *)value;
- (void)removeMovesObject:(NSManagedObject *)value;
- (void)addMoves:(NSSet *)values;
- (void)removeMoves:(NSSet *)values;

@end
