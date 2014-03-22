//
//  PKEPokemon.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPokemon.h"
#import "PKEMove.h"

@implementation PKEPokemon
{
}

#pragma mark - Public Methods

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

#pragma mark - MTLManagedObjectSerializing

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             @"identifier" : @"identifier",
             @"name" : @"name",
             @"firstType" : @"firstType",
             @"secondType" : @"secondType",
             @"pokedexNumber" : [NSNull null],
             @"moves" : @"moves"
            };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             @"moves" : [PKEMove class],
            };
}

+ (NSString *)managedObjectEntityName
{
    return @"PKEPokemonManagedObject";
}

@end
