//
//  PKEDataBaseManager.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPokemonManager.h"
#import "PKEPokemon.h"
#import "PKEMove.h"
#import "PKEQueryHelper.h"
#import "PKEFormatHelper.h"
#import "PKESQLiteHelper.h"
#import "PKECoreDataHelper.h"

@interface PKEPokemonManager ()

@property (nonatomic, strong) PKEFormatHelper *formatHelper;
@property (nonatomic, strong) PKESQLiteHelper *sqliteHelper;
@property (nonatomic, strong) PKECoreDataHelper *coreDataHelper;

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
    });
    return _sharedManager;
}

#pragma mark - Private Methods

- (PKEFormatHelper *)formatHelper
{
    if (_formatHelper == nil) {
        _formatHelper = [PKEFormatHelper new];
    }
    return _formatHelper;
}

- (PKESQLiteHelper *)sqliteHelper
{
    if (_sqliteHelper == nil) {
        _sqliteHelper = [PKESQLiteHelper new];
    }
    return _sqliteHelper;
}

- (PKECoreDataHelper *)coreDataHelper
{
    if (_coreDataHelper == nil) {
        _coreDataHelper = [PKECoreDataHelper new];
    }
    return _coreDataHelper;
}

#pragma mark - Public Methods

- (void)getPokemonsWithCompletion:(ArrayCompletionBlock)completionBlock
{
    [[self sqliteHelper] getPokemonsWithFilteringPokemonType:[self filteringPokemonType]
                                        filteringPokedexType:[self filteringPokedexType]
                                                  completion:completionBlock];
}

- (void)addPokemonToParty:(PKEPokemon *)pokemon
               completion:(BooleanCompletionBlock)completionBlock;
{
    [[self coreDataHelper] addPokemonToParty:pokemon
                                  completion:completionBlock];
}

- (void)removePokemonFromParty:(PKEPokemon *)pokemon
                    completion:(BooleanCompletionBlock)completionBlock
{
    [[self coreDataHelper] removePokemonFromParty:pokemon
                                       completion:completionBlock];
}

- (void)getPartyWithCompletion:(ArrayCompletionBlock)completionBlock
{
    [[self coreDataHelper] getPartyWithCompletion:completionBlock];
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
