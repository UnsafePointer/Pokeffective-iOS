//
//  PKEDataBaseManager.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKEPokemonManager : NSObject

@property (nonatomic, assign) PKEPokedexType filteringPokedexType;
@property (nonatomic, assign) PKEPokemonType filteringPokemonType;

+ (instancetype)sharedManager;
- (NSArray *)getPokemons;
- (UIColor *)colorForType:(PKEPokemonType)pokemonType;
- (NSString *)nameForType:(PKEPokemonType)pokemonType;
- (PKEPokedexType)pokedexTypeForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForPokedexType:(PKEPokedexType)pokedexType;

- (NSArray *)getParty;
- (NSArray *)getMoveset;
- (NSString *)getRandomEffective;

- (UIColor *)getColorForEffective:(NSString *)effective;

@end
