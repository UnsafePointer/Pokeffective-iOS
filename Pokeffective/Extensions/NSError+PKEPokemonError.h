//
//  NSError+PokemonError.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PKEErrorPokemonDomain;
extern NSString * const PKEErrorMoveDomain;

@interface NSError (PKEPokemonError)

+ (NSError *)PKE_errorSavingSamePokemon;
+ (NSError *)PKE_errorSavingSameMove;

@end
