//
//  PKESQLiteHelper.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKESQLiteHelper : NSObject

- (void)getPokemonsWithFilteringPokemonType:(PKEPokemonType)pokemonType
                       filteringPokedexType:(PKEPokedexType)pokedexType
                                 completion:(ArrayCompletionBlock)completionBlock;

@end
