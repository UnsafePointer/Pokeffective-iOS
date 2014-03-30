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
#import "PKEIAPHelper.h"

@interface PKEPokemonManager ()

@property (nonatomic, strong) PKEFormatHelper *formatHelper;
@property (nonatomic, strong) PKESQLiteHelper *sqliteHelper;
@property (nonatomic, strong) PKECoreDataHelper *coreDataHelper;
@property (nonatomic, strong) PKEIAPHelper *IAPHelper;

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

- (PKEIAPHelper *)IAPHelper
{
    if (_IAPHelper == nil) {
        _IAPHelper = [PKEIAPHelper new];
    }
    return _IAPHelper;
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
            NSMutableArray *STABs = [NSMutableArray array];
            for (PKEPokemon *pokemon in party) {
                for (PKEMove *move in [pokemon moves]) {
                    PKEEffectiveness comparison = [[typeEfficacy objectAtIndex:([move type] - 1)] unsignedIntegerValue];
                    if (comparison > effectiviness) {
                        effectiviness = comparison;
                    }
                    if (comparison == PKEEffectivenessSuperEffective) {
                        if ([move type] == [pokemon firstType] || [move type] == [pokemon secondType]) {
                            if ([move category] != PKEMoveCategoryNonDamaging) {
                                PKESTAB *STAB = [PKESTAB new];
                                [STAB setPokemon:pokemon];
                                [STAB setMove:move];
                                [STABs addObject:STAB];
                            }
                        }
                    }
                }
            }
            PKEEffective *effective = [PKEEffective new];
            [effective setPokemonType:pokemonTypeTarget];
            [effective setEffectiveness:effectiviness];
            [effective setSTABs:[STABs copy]];
            [pokeffective addObject:effective];
        }
        if (completionBlock) {
            completionBlock(pokeffective, nil);
        }
    }];
}

- (void)getProductsWithIdentifiers:(NSSet *)identifiers
                        completion:(ArrayCompletionBlock)completionBlock
{
    [[self IAPHelper] getProductsWithIdentifiers:identifiers
                                      completion:completionBlock];
}

- (void)buyProduct:(SKProduct *)product
{
    [[self IAPHelper] buyProduct:product];
}

- (void)completeTransaction:(SKPaymentTransaction *)paymentTransaction
{
    [[self IAPHelper] completeTransaction:paymentTransaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)paymentTransaction
{
    [[self IAPHelper] restoreTransaction:paymentTransaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)paymentTransaction
{
    [[self IAPHelper] failedTransaction:paymentTransaction];
}

- (void)restoreCompletedTransactions
{
    [[self IAPHelper] restoreCompletedTransactions];
}

- (BOOL)isIAPContentAvailable
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:IAP_IDENTIFIER];
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

- (PKEPokemonType)pokemonTypeForIndexPath:(NSIndexPath *)indexPath
{
    return [[self formatHelper] pokemonTypeForIndexPath:indexPath];
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

- (NSIndexPath *)indexPathForPokemonType:(PKEPokemonType)pokemonType
{
    return [[self formatHelper] indexPathForPokemonType:pokemonType];
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
