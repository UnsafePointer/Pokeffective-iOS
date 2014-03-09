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

- (UIColor *)getColorForType:(NSString *)type
{
    NSDictionary *colors = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Types"
                                                                                                      ofType:@"plist"]];
    return [UIColor colorWithHexString:[colors objectForKey:type]];
}

@end
