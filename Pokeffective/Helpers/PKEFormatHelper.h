//
//  PKETypeHelper.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 15/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKEFormatHelper : NSObject

- (UIColor *)colorForType:(PKEPokemonType)pokemonType;
- (NSString *)nameForType:(PKEPokemonType)pokemonType;
- (NSString *)nameForCategory:(PKEMoveCategory)moveCategory;
- (NSString *)nameForEffectiveness:(PKEEffectiveness)effectiveness;
- (PKEPokedexType)pokedexTypeForIndexPath:(NSIndexPath *)indexPath;
- (PKEMoveMethod)moveMethodForIndexPath:(NSIndexPath *)indexPath;
- (PKEMoveCategory)moveCategoryForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForPokedexType:(PKEPokedexType)pokedexType;
- (NSIndexPath *)indexPathForMoveCategory:(PKEMoveCategory)moveCategory;
- (NSIndexPath *)indexPathForMoveMethod:(PKEMoveMethod)moveMethod;

@end
