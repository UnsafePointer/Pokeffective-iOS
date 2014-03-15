//
//  PKEQueryHelper.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 15/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKEQueryHelper : NSObject

- (NSString *)pokemonSearchQueryFilterByPokedexType:(PKEPokedexType)pokedexType
                                        pokemonType:(PKEPokemonType)pokemonType
                                           typeSlot:(NSUInteger)typeSlot;
- (NSString *)pokemonTypeQueryByIdentifier:(NSUInteger)identifier
                                  typeSlot:(NSUInteger)typeSlot;

@end
