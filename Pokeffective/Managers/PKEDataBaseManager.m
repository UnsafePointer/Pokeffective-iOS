//
//  PKEDataBaseManager.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEDataBaseManager.h"
#import "PKEPokemon.h"
#import "HexColor.h"
#import "PKEMove.h"

@interface PKEDataBaseManager ()

@end

@implementation PKEDataBaseManager

#pragma mark - Class Methods

static dispatch_once_t oncePredicate;

+ (instancetype)sharedManager
{
    static id _sharedManager;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Public Methods

- (NSArray *)getPokemons
{
    NSArray *database = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Pokemons"
                                                                                         ofType:@"plist"]];
    NSMutableArray *pokemons = [[NSMutableArray alloc] initWithCapacity:[database count]];
    for(NSDictionary *pokemon in database) {
        PKEPokemon *model = [PKEPokemon createPokemonWithDictionary:pokemon];
        [pokemons addObject:model];
    }
    return pokemons;
}

- (NSArray *)getParty
{
    NSArray *database = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Party"
                                                                                         ofType:@"plist"]];
    NSMutableArray *pokemons = [[NSMutableArray alloc] initWithCapacity:[database count]];
    for(NSDictionary *pokemon in database) {
        PKEPokemon *model = [PKEPokemon createPokemonWithDictionary:pokemon];
        [pokemons addObject:model];
    }
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

- (UIColor *)getColorForType:(NSString *)type
{
    NSDictionary *colors = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Types"
                                                                                                      ofType:@"plist"]];
    return [UIColor colorWithHexString:[colors objectForKey:type]];
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
