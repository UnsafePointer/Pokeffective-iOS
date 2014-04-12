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
        NSMutableArray *moves = [[NSMutableArray alloc] init];
        BOOL preEvolutionSearch = ([[pokemon isEvolution] boolValue] && (moveMethod == PKEMoveMethodAll || moveMethod == PKEMoveMethodEgg));
        if (preEvolutionSearch) {
            int preEvolutionIdentifier = 0;
            BOOL found = NO;
            do {
                NSString *query = nil;
                if (preEvolutionIdentifier == 0) {
                    query = [[self queryHelper] preEvolutionWithIdentifier:[pokemon identifier]];
                }
                else {
                    query = [[self queryHelper] preEvolutionWithIdentifier:preEvolutionIdentifier];
                }
                FMResultSet *resultSet = [db executeQuery:query];
                if ([resultSet next]) {
                    int result = [resultSet intForColumn:@"prevolution"];
                    if (result != 0) {
                        preEvolutionIdentifier = result;
                    }
                    else {
                        found = YES;
                    }
                }
            } while (!found);
            PKEPokemon *stubPokemon = [PKEPokemon new];
            [stubPokemon setIdentifier:preEvolutionIdentifier];
            NSString *query = [[self queryHelper] moveSearchQueryFilterByMoveMethod:PKEMoveMethodEgg
                                                                           moveType:moveType
                                                                       moveCategory:moveCategory
                                                                        fromPokemon:stubPokemon];
            FMResultSet *resultSet = [db executeQuery:query];
            while ([resultSet next]) {
                PKEMove *model = [PKEMove createMoveWithResultSet:resultSet];
                [moves addObject:model];
            }
        }
        NSString *query = [[self queryHelper] moveSearchQueryFilterByMoveMethod:moveMethod
                                                                       moveType:moveType
                                                                   moveCategory:moveCategory
                                                                    fromPokemon:pokemon];
        FMResultSet *resultSet = [db executeQuery:query];
        while ([resultSet next]) {
            PKEMove *model = [PKEMove createMoveWithResultSet:resultSet];
            [moves addObject:model];
        }
        [db close];
        if (preEvolutionSearch) {
            if (completionBlock) {
                NSMutableDictionary *movesFiltered = [NSMutableDictionary dictionary];
                for (PKEMove *move in moves) {
                    [movesFiltered setObject:move
                                      forKey:[move name]];
                }
                completionBlock([[movesFiltered objectsForKeys:[movesFiltered allKeys]
                                                notFoundMarker:[PKEMove new]]
                                 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [[(PKEMove *)obj1 name] compare:[(PKEMove *)obj2 name]
                                                   options:NSCaseInsensitiveSearch];
                }], nil);
            }
        }
        else {
            if (completionBlock) {
                completionBlock(moves, nil);
            }
        }
    }];
}

- (void)getEfficacyWithType:(PKEAnalysisType)type
                 completion:(ObjectCompletionBlock)completionBlock
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[NSBundle mainBundle]
                                                                     pathForResource:@"PokeffectiveData"
                                                                     ofType:@"sqlite"]];
    @weakify(self);
    [queue inDatabase:^(FMDatabase *db) {
        @strongify(self);
        NSString *query = [[self queryHelper] efficacy];
        FMResultSet *resultSet = [db executeQuery:query];
        NSMutableDictionary *efficacy = [[NSMutableDictionary alloc] init];
        while ([resultSet next]) {
            PKEPokemonType damager = [resultSet intForColumn:@"damager"];
            PKEPokemonType target = [resultSet intForColumn:@"target"];
            PKEEffectiveness effectiveness = [resultSet intForColumn:@"factor"];
            if (type == PKEAnalysisTypeAttack) {
                NSMutableArray *type = [efficacy objectForKey:[NSNumber numberWithInt:target]];
                if (!type) {
                    type = [[NSMutableArray alloc] initWithCapacity:TOTAL_POKEMON_TYPES];
                    for (int i = 0; i < TOTAL_POKEMON_TYPES; i++) {
                        [type addObject:[NSNull null]];
                    }
                }
                [type replaceObjectAtIndex:(damager - 1)
                                withObject:[NSNumber numberWithInt:effectiveness]];
                [efficacy setObject:type
                             forKey:[NSNumber numberWithInt:target]];
            }
            else {
                NSMutableArray *type = [efficacy objectForKey:[NSNumber numberWithInt:damager]];
                if (!type) {
                    type = [[NSMutableArray alloc] initWithCapacity:TOTAL_POKEMON_TYPES];
                    for (int i = 0; i < TOTAL_POKEMON_TYPES; i++) {
                        [type addObject:[NSNull null]];
                    }
                }
                [type replaceObjectAtIndex:(target - 1)
                                withObject:[NSNumber numberWithInt:effectiveness]];
                [efficacy setObject:type
                             forKey:[NSNumber numberWithInt:damager]];
            }
        }
        [db close];
        if (completionBlock) {
            completionBlock([efficacy copy], nil);
        }
    }];
}

@end
