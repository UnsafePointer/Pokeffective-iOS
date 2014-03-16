//
//  PKEDataBaseManager.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKEPokemon;

@interface PKEPokemonManager : NSObject

@property (nonatomic, assign) PKEPokedexType filteringPokedexType;
@property (nonatomic, assign) PKEPokemonType filteringPokemonType;

+ (instancetype)sharedManager;

- (void)getPokemonsWithCompletion:(ArrayCompletionBlock)completionBlock;
- (void)addPokemonToParty:(PKEPokemon *)pokemon
               completion:(BooleanCompletionBlock)completionBlock;
- (void)removePokemonFromParty:(PKEPokemon *)pokemon
                    completion:(BooleanCompletionBlock)completionBlock;
- (void)getPartyWithCompletion:(ArrayCompletionBlock)completionBlock;

- (UIColor *)colorForType:(PKEPokemonType)pokemonType;
- (NSString *)nameForType:(PKEPokemonType)pokemonType;
- (PKEPokedexType)pokedexTypeForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForPokedexType:(PKEPokedexType)pokedexType;

- (NSArray *)getMoveset;
- (NSString *)getRandomEffective;
- (UIColor *)getColorForEffective:(NSString *)effective;

@end
