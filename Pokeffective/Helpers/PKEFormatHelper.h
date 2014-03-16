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
- (PKEPokedexType)pokedexTypeForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForPokedexType:(PKEPokedexType)pokedexType;

@end
