//
//  PKESQLiteHelper.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKEPokemon;

@interface PKESQLiteHelper : NSObject

- (void)getPokemonsWithFilteringPokemonType:(PKEPokemonType)pokemonType
                       filteringPokedexType:(PKEPokedexType)pokedexType
                                 completion:(ArrayCompletionBlock)completionBlock;
- (void)getMovesForPokemon:(PKEPokemon *)pokemon
         filteringMoveType:(PKEPokemonType)moveType
       filteringMoveMethod:(PKEMoveMethod)moveMethod
     filteringMoveCategory:(PKEMoveCategory)moveCategory
                completion:(ArrayCompletionBlock)completionBlock;

@end
