//
//  PKEDataBaseManager.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKEPokemon;
@class PKEMove;

@interface PKEPokemonManager : NSObject

@property (nonatomic, assign) PKEPokedexType filteringPokedexType;
@property (nonatomic, assign) PKEPokemonType filteringPokemonType;
@property (nonatomic, assign) PKEPokemonType filteringMoveType;
@property (nonatomic, assign) PKEMoveMethod filteringMoveMethod;
@property (nonatomic, assign) PKEMoveCategory filteringMoveCategory;
@property (nonatomic, assign) CGFloat progress;

+ (instancetype)sharedManager;

- (void)getPokemonsWithCompletion:(ArrayCompletionBlock)completionBlock;
- (void)getPartyWithCompletion:(ArrayCompletionBlock)completionBlock;
- (void)addPokemonToParty:(PKEPokemon *)pokemon
               completion:(BooleanCompletionBlock)completionBlock;
- (void)removePokemonFromParty:(PKEPokemon *)pokemon
                    completion:(BooleanCompletionBlock)completionBlock;
- (void)getMovesForPokemon:(PKEPokemon *)pokemon
                completion:(ArrayCompletionBlock)completionBlock;
- (void)addMove:(PKEMove *)move
      toPokemon:(PKEPokemon *)pokemon
     completion:(BooleanCompletionBlock)completionBlock;
- (void)removeMove:(PKEMove *)move
         toPokemon:(PKEPokemon *)pokemon
        completion:(BooleanCompletionBlock)completionBlock;
- (void)calculatePokeffectiveWithParty:(NSArray *)party
                            completion:(ArrayCompletionBlock)completionBlock;

- (UIColor *)colorForType:(PKEPokemonType)pokemonType;
- (NSString *)nameForType:(PKEPokemonType)pokemonType;
- (NSString *)nameForCategory:(PKEMoveCategory)moveCategory;
- (NSString *)nameForEffectiveness:(PKEEffectiveness)effectiveness;

- (PKEPokedexType)pokedexTypeForIndexPath:(NSIndexPath *)indexPath;
- (PKEMoveCategory)moveCategoryForIndexPath:(NSIndexPath *)indexPath;
- (PKEMoveMethod)moveMethodForIndexPath:(NSIndexPath *)indexPath;
- (PKEPokemonType)pokemonTypeForIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathForPokedexType:(PKEPokedexType)pokedexType;
- (NSIndexPath *)indexPathForMoveMethod:(PKEMoveMethod)moveMethod;
- (NSIndexPath *)indexPathForMoveCategory:(PKEMoveCategory)moveCategory;
- (NSIndexPath *)indexPathForPokemonType:(PKEPokemonType)pokemonType;

- (UIColor *)getColorForEffective:(NSString *)effective;

@end
