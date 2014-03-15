//
//  PKEDataBaseManager.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPokemonManager.h"
#import "PKEPokemon.h"
#import "HexColor.h"
#import "PKEMove.h"
#import "PKEQueryHelper.h"
#import "PKEFormatHelper.h"
#import <FMDB/FMDatabase.h>

@interface PKEPokemonManager ()

@property (nonatomic, strong) FMDatabase *database;

@property (nonatomic, strong) PKEQueryHelper *queryHelper;
@property (nonatomic, strong) PKEFormatHelper *formatHelper;

@end

@implementation PKEPokemonManager

#pragma mark - Class Methods

static dispatch_once_t oncePredicate;

+ (instancetype)sharedManager
{
    static PKEPokemonManager *_sharedManager;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
        [_sharedManager setFilteringPokedexType:PKEPokedexTypeNational];
        [_sharedManager setFilteringPokemonType:PKEPokemonTypeNone];
        [_sharedManager setDatabase:[FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"Pokeffective"
                                                                                                 ofType:@"sqlite"]]];
    });
    return _sharedManager;
}

#pragma mark - Private Methods

- (PKEQueryHelper *)queryHelper
{
    if (_queryHelper == nil) {
        _queryHelper = [PKEQueryHelper new];
    }
    return _queryHelper;
}

- (PKEFormatHelper *)formatHelper
{
    if (_formatHelper == nil) {
        _formatHelper = [PKEFormatHelper new];
    }
    return _formatHelper;
}

#pragma mark - Public Methods

- (NSArray *)getPokemons
{
    [[self database] open];
    NSMutableDictionary *pokemons = [[NSMutableDictionary alloc] init];
    if ([self filteringPokemonType] == PKEPokemonTypeNone) {
        NSString *query = [[self queryHelper] pokemonSearchQueryFilterByPokedexType:[self filteringPokedexType]
                                                                        pokemonType:[self filteringPokemonType]
                                                                           typeSlot:FIRST_TYPE_SLOT];
        FMResultSet *resultSet = [[self database] executeQuery:query];
        while ([resultSet next]) {
            PKEPokemon *model = [PKEPokemon createPokemonWithResultSet:resultSet];
            [pokemons setObject:model forKey:[model name]];
        }
        query = [[self queryHelper] pokemonSearchQueryFilterByPokedexType:[self filteringPokedexType]
                                                              pokemonType:[self filteringPokemonType]
                                                                 typeSlot:SECOND_TYPE_SLOT];
        resultSet = [[self database] executeQuery:query];
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"];
            PKEPokemon *model = [pokemons objectForKey:[name capitalizedString]];
            [model setSecondType:[resultSet intForColumn:@"type"]];
        }
    }
    else {
        NSString *query = [[self queryHelper] pokemonSearchQueryFilterByPokedexType:[self filteringPokedexType]
                                                                        pokemonType:[self filteringPokemonType]
                                                                           typeSlot:FIRST_TYPE_SLOT];
        FMResultSet *resultSet = [[self database] executeQuery:query];
        while ([resultSet next]) {
            PKEPokemon *model = [PKEPokemon createPokemonWithResultSet:resultSet];
            [pokemons setObject:model forKey:[model name]];
            NSString *secondTypeQuery = [[self queryHelper] pokemonTypeQueryByIdentifier:[model identifier]
                                                                                typeSlot:SECOND_TYPE_SLOT];
            FMResultSet *secondTypeResultSet = [[self database] executeQuery:secondTypeQuery];
            while ([secondTypeResultSet next]) {
                [model setSecondType:[secondTypeResultSet intForColumn:@"type"]];
            }
        }
        query = [[self queryHelper] pokemonSearchQueryFilterByPokedexType:[self filteringPokedexType]
                                                              pokemonType:[self filteringPokemonType]
                                                                 typeSlot:SECOND_TYPE_SLOT];
        resultSet = [[self database] executeQuery:query];
        while ([resultSet next]) {
            PKEPokemon *model = [PKEPokemon createPokemonWithResultSet:resultSet];
            [pokemons setObject:model forKey:[model name]];
            NSString *firstTypeQuery = [[self queryHelper] pokemonTypeQueryByIdentifier:[model identifier]
                                                                                typeSlot:FIRST_TYPE_SLOT];
            FMResultSet *firstTypeResultSet = [[self database] executeQuery:firstTypeQuery];
            while ([firstTypeResultSet next]) {
                [model setSecondType:[model firstType]];
                [model setFirstType:[firstTypeResultSet intForColumn:@"type"]];
            }
        }
    }
    [[self database] close];
    return [[pokemons allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(PKEPokemon *)obj1 pokedexNumber] > [(PKEPokemon *)obj2 pokedexNumber];
    }];
}

- (NSArray *)getParty
{
    NSArray *database = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Party"
                                                                                         ofType:@"plist"]];
    NSMutableArray *pokemons = [[NSMutableArray alloc] initWithCapacity:[database count]];
    return pokemons;
}

- (NSArray *)getMoveset
{
    NSArray *database = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Moveset"
                                                                                         ofType:@"plist"]];
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:[database count]];
    for(NSDictionary *move in database) {
        PKEMove *model = [PKEMove createMoveWithDictionary:move];
        [moves addObject:model];
    }
    return moves;
}

- (UIColor *)colorForType:(PKEPokemonType)pokemonType
{
    return [[self formatHelper] colorForType:pokemonType];
}


- (NSString *)nameForType:(PKEPokemonType)pokemonType
{
    return [[self formatHelper] nameForType:pokemonType];
}

- (PKEPokedexType)pokedexTypeForIndexPath:(NSIndexPath *)indexPath
{
    return [[self formatHelper] pokedexTypeForIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForPokedexType:(PKEPokedexType)pokedexType
{
    return [[self formatHelper] indexPathForPokedexType:pokedexType];
}

- (NSString *)getRandomEffective
{
    int random = arc4random()%4;
    switch (random) {
        case 0:
            return @"No effect";
        case 1:
            return @"Not very effective";
        case 2:
            return @"Normal";
        case 3:
            return @"Super-effective";
    }
    return nil;
}

- (UIColor *)getColorForEffective:(NSString *)effective
{
    if ([effective isEqualToString:@"No effect"]) {
        return [UIColor colorWithHexString:@"#4A4A4A"];
    }
    if ([effective isEqualToString:@"Not very effective"]) {
        return [UIColor colorWithHexString:@"#FF3A2D"];
    }
    if ([effective isEqualToString:@"Normal"]) {
        return [UIColor colorWithHexString:@"#F7F7F7"];
    }
    if ([effective isEqualToString:@"Super-effective"]) {
        return [UIColor colorWithHexString:@"#0BD318"];
    }
    return nil;
}

@end
