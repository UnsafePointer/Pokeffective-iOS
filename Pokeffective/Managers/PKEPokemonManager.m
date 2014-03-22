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
#import "PKEEffective.h"
#import "PKESTAB.h"

@interface PKEPokemonManager ()

@property (nonatomic, strong) PKEFormatHelper *formatHelper;
@property (nonatomic, strong) PKESQLiteHelper *sqliteHelper;
@property (nonatomic, strong) PKECoreDataHelper *coreDataHelper;

- (void)getEfficacyWithCompletion:(ObjectCompletionBlock)completionBlock;

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
        [_sharedManager setFilteringMoveMethod:PKEMoveMethodAll];
        [_sharedManager setFilteringMoveType:PKEPokemonTypeNone];
        [_sharedManager setFilteringMoveCategory:PKEMoveCategoryAll];
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

- (void)getMovesForPokemon:(PKEPokemon *)pokemon
                completion:(ArrayCompletionBlock)completionBlock
{
    [[self sqliteHelper] getMovesForPokemon:pokemon
                          filteringMoveType:[self filteringMoveType]
                        filteringMoveMethod:[self filteringMoveMethod]
                      filteringMoveCategory:[self filteringMoveCategory]
                                 completion:completionBlock];
}

- (void)addMove:(PKEMove *)move
      toPokemon:(PKEPokemon *)pokemon
     completion:(BooleanCompletionBlock)completionBlock
{
    [[self coreDataHelper] addMove:move
                         toPokemon:pokemon
                        completion:completionBlock];
}

- (void)removeMove:(PKEMove *)move
         toPokemon:(PKEPokemon *)pokemon
        completion:(BooleanCompletionBlock)completionBlock
{
    [[self coreDataHelper] removeMove:move
                            toPokemon:pokemon
                           completion:completionBlock];
}

- (void)getEfficacyWithCompletion:(ObjectCompletionBlock)completionBlock
{
    [[self sqliteHelper] getEfficacyWithCompletion:completionBlock];
}

- (void)calculatePokeffectiveWithParty:(NSArray *)party
                            completion:(ArrayCompletionBlock)completionBlock;
{
    [self getEfficacyWithCompletion:^(id object, NSError *error) {
        NSDictionary *efficacy = (NSDictionary *)object;
        NSMutableArray *pokeffective = [NSMutableArray arrayWithCapacity:TOTAL_POKEMON_TYPES];
        for (PKEPokemonType pokemonTypeTarget = PKEPokemonTypeNormal; pokemonTypeTarget <= TOTAL_POKEMON_TYPES; pokemonTypeTarget++) {
            NSArray *typeEfficacy = [efficacy objectForKey:[NSNumber numberWithInt:pokemonTypeTarget]];
            PKEEffectiveness effectiviness = PKEEffectivenessNoEffect;
            NSMutableArray *STABers = [NSMutableArray array];
            for (PKEPokemon *pokemon in party) {
                PKESTAB *STAB = nil;
                for (PKEMove *move in [pokemon moves]) {
                    PKEEffectiveness comparison = [[typeEfficacy objectAtIndex:([move type] - 1)] unsignedIntegerValue];
                    if (comparison > effectiviness) {
                        effectiviness = comparison;
                    }
                    if (effectiviness == PKEEffectivenessSuperEffective) {
                        if ([move type] == [pokemon firstType] || [move type] == [pokemon secondType]) {
                            NSMutableArray *moves = nil;
                            if (STAB == nil) {
                                STAB = [PKESTAB new];
                                [STAB setPokemon:pokemon];
                                moves = [[NSMutableArray alloc] init];
                            }
                            else {
                                moves = [NSMutableArray arrayWithArray:[STAB moves]];
                            }
                            [moves addObject:move];
                            [STAB setMoves:[moves copy]];
                        }
                    }
                }
                if (STAB) {
                    [STABers addObject:STAB];
                }
            }
            PKEEffective *effective = [PKEEffective new];
            [effective setPokemonType:pokemonTypeTarget];
            [effective setEffectiveness:effectiviness];
            [effective setSTABers:[STABers copy]];
            [pokeffective addObject:effective];
        }
        if (completionBlock) {
            completionBlock(pokeffective, nil);
        }
    }];
}

- (UIColor *)colorForType:(PKEPokemonType)pokemonType
{
    return [[self formatHelper] colorForType:pokemonType];
}

- (NSString *)nameForType:(PKEPokemonType)pokemonType
{
    return [[self formatHelper] nameForType:pokemonType];
}

- (NSString *)nameForCategory:(PKEMoveCategory)moveCategory
{
    return [[self formatHelper] nameForCategory:moveCategory];
}

- (NSString *)nameForEffectiveness:(PKEEffectiveness)effectiveness
{
    return [[self formatHelper] nameForEffectiveness:effectiveness];
}

- (PKEPokedexType)pokedexTypeForIndexPath:(NSIndexPath *)indexPath
{
    return [[self formatHelper] pokedexTypeForIndexPath:indexPath];
}

- (PKEMoveCategory)moveCategoryForIndexPath:(NSIndexPath *)indexPath
{
    return [[self formatHelper] moveCategoryForIndexPath:indexPath];
}

- (PKEMoveMethod)moveMethodForIndexPath:(NSIndexPath *)indexPath
{
    return [[self formatHelper] moveMethodForIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForPokedexType:(PKEPokedexType)pokedexType
{
    return [[self formatHelper] indexPathForPokedexType:pokedexType];
}

- (NSIndexPath *)indexPathForMoveMethod:(PKEMoveMethod)moveMethod
{
    return [[self formatHelper] indexPathForMoveMethod:moveMethod];
}

- (NSIndexPath *)indexPathForMoveCategory:(PKEMoveCategory)moveCategory
{
    return [[self formatHelper] indexPathForMoveCategory:moveCategory];
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
