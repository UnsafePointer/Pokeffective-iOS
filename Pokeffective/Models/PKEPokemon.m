//
//  PKEPokemon.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <FMDB/FMResultSet.h>
#import "PKEPokemon.h"

@implementation PKEPokemon

+ (PKEPokemon *)createPokemonWithResultSet:(FMResultSet *)resultSet
{
    PKEPokemon *pokemon = [PKEPokemon new];
    [pokemon setIdentifier:[resultSet intForColumn:@"identifier"]];
    [pokemon setName:[[resultSet stringForColumn:@"name"] capitalizedString]];
    [pokemon setPokedexNumber:[resultSet intForColumn:@"number"]];
    [pokemon setFirstType:[resultSet intForColumn:@"type"]];
    [pokemon setSecondType:PKEPokemonTypeNone];
    return pokemon;
}

@end
