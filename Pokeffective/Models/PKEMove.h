//
//  PKEMove.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKEMove : MTLModel <MTLManagedObjectSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) PKEPokemonType type;
@property (nonatomic, assign) PKEMoveCategory category;
@property (nonatomic, assign) NSUInteger power;
@property (nonatomic, assign) NSUInteger accuracy;

+ (PKEMove *)createMoveWithDictionary:(NSDictionary *)dictionary;

@end
