//
//  PKESQLiteHelper.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKESQLiteHelper.h"
#import "PKEQueryHelper.h"
#import "PKEPokemon.h"
#import "PKEMove.h"

@interface PKESQLiteHelper ()

@property (nonatomic, strong) PKEQueryHelper *queryHelper;

@end

@implementation PKESQLiteHelper
{
}

#pragma mark - Private Methods

- (PKEQueryHelper *)queryHelper
{
    if (_queryHelper == nil) {
        _queryHelper = [PKEQueryHelper new];
    }
    return _queryHelper;
}

#pragma mark - Public Methods

- (void)getPokemonsWithFilteringPokemonType:(PKEPokemonType)pokemonType
                       filteringPokedexType:(PKEPokedexType)pokedexType
                                 completion:(ArrayCompletionBlock)completionBlock
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[NSBundle mainBundle]
                                                                     pathForResource:@"PokeffectiveData"
                                                                     ofType:@"sqlite"]];
    if (pokemonType == PKEPokemonTypeNone) {
        @weakify(self);
        [queue inDatabase:^(FMDatabase *db) {
            @strongify(self)
            NSString *firstTypeQuery = [[self queryHelper] pokemonSearchQueryFilterByPokedexType:pokedexType
                                                                                     pokemonType:pokemonType
                                                                                        typeSlot:FIRST_TYPE_SLOT];
            NSString *secondTypeQuery = [[self queryHelper] pokemonSearchQueryFilterByPokedexType:pokedexType
                                                                                      pokemonType:pokemonType
                                                                                         typeSlot:SECOND_TYPE_SLOT];
            NSMutableDictionary *pokemons = [[NSMutableDictionary alloc] init];
            FMResultSet *firstTypeResultSet = [db executeQuery:firstTypeQuery];
            while ([firstTypeResultSet next]) {
                PKEPokemon *model = [PKEPokemon createPokemonWithResultSet:firstTypeResultSet];
                [pokemons setObject:model forKey:[model name]];
            }
            FMResultSet *secondTypeResultSet = [db executeQuery:secondTypeQuery];
            while ([secondTypeResultSet next]) {
                NSString *name = [secondTypeResultSet stringForColumn:@"name"];
                PKEPokemon *model = [pokemons objectForKey:[name capitalizedString]];
                [model setSecondType:[secondTypeResultSet intForColumn:@"type"]];
            }
            [db close];
            if (completionBlock) {
                completionBlock([[pokemons allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(PKEPokemon *)obj1 pokedexNumber] > [(PKEPokemon *)obj2 pokedexNumber];
                }], nil);
            }
        }];
    }
    else {
        @weakify(self);
        [queue inDatabase:^(FMDatabase *db) {
            @strongify(self)
            NSString *firstTypeQuery = [[self queryHelper] pokemonSearchQueryFilterByPokedexType:pokedexType
                                                                                     pokemonType:pokemonType
                                                                                        typeSlot:FIRST_TYPE_SLOT];
            NSString *secondTypeQuery = [[self queryHelper] pokemonSearchQueryFilterByPokedexType:pokedexType
                                                                                      pokemonType:pokemonType
                                                                                         typeSlot:SECOND_TYPE_SLOT];
            NSMutableDictionary *pokemons = [[NSMutableDictionary alloc] init];
            FMResultSet *firstTypeResultSet = [db executeQuery:firstTypeQuery];
            while ([firstTypeResultSet next]) {
                PKEPokemon *model = [PKEPokemon createPokemonWithResultSet:firstTypeResultSet];
                [pokemons setObject:model forKey:[model name]];
                NSString *secondInnerTypeQuery = [[self queryHelper] pokemonTypeQueryByIdentifier:[model identifier]
                                                                                         typeSlot:SECOND_TYPE_SLOT];
                FMResultSet *secondInnerTypeResultSet = [db executeQuery:secondInnerTypeQuery];
                while ([secondInnerTypeResultSet next]) {
                    [model setSecondType:[secondInnerTypeResultSet intForColumn:@"type"]];
                }
            }
            FMResultSet *secondTypeResultSet = [db executeQuery:secondTypeQuery];
            while ([secondTypeResultSet next]) {
                PKEPokemon *model = [PKEPokemon createPokemonWithResultSet:secondTypeResultSet];
                [pokemons setObject:model forKey:[model name]];
                NSString *firstInnerTypeQuery = [[self queryHelper] pokemonTypeQueryByIdentifier:[model identifier]
                                                                                        typeSlot:FIRST_TYPE_SLOT];
                FMResultSet *firstInnerTypeResultSet = [db executeQuery:firstInnerTypeQuery];
                while ([firstInnerTypeResultSet next]) {
                    [model setSecondType:[model firstType]];
                    [model setFirstType:[firstInnerTypeResultSet intForColumn:@"type"]];
                }
            }
            [db close];
            if (completionBlock) {
                completionBlock([[pokemons allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [(PKEPokemon *)obj1 pokedexNumber] > [(PKEPokemon *)obj2 pokedexNumber];
                }], nil);
            }
        }];
    }
}

- (void)getMovesForPokemon:(PKEPokemon *)pokemon
         filteringMoveType:(PKEPokemonType)moveType
       filteringMoveMethod:(PKEMoveMethod)moveMethod
     filteringMoveCategory:(PKEMoveCategory)moveCategory
                completion:(ArrayCompletionBlock)completionBlock
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[NSBundle mainBundle]
                                                                      pathForResource:@"PokeffectiveData"
                                                                      ofType:@"sqlite"]];
    @weakify(self);
    [queue inDatabase:^(FMDatabase *db) {
        @strongify(self);
        NSString *query = [[self queryHelper] moveSearchQueryFilterByMoveMethod:moveMethod
                                                                       moveType:moveType
                                                                   moveCategory:moveCategory
                                                                    fromPokemon:pokemon];
        FMResultSet *resultSet = [db executeQuery:query];
        NSMutableArray *moves = [[NSMutableArray alloc] init];
        while ([resultSet next]) {
            PKEMove *model = [PKEMove createMoveWithResultSet:resultSet];
            [moves addObject:model];
        }
        [db close];
        if (completionBlock) {
            completionBlock(moves, nil);
        }
    }];
}

@end
