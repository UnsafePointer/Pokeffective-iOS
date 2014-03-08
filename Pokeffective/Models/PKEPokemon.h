//
//  PKEPokemon.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKEPokemon : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *number;
@property (nonatomic, copy) NSArray *types;

+ (PKEPokemon *)createPokemonWithDictionary:(NSDictionary *)dictionary;

@end
