//
//  NSError+PokemonError.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "NSError+PokemonError.h"

NSString * const PKEErrorPokemonDomain = @"PKEErrorPokemonDomain";
NSString * const PKEErrorMoveDomain = @"PKEErrorMoveDomain";

@implementation NSError (PokemonError)

+ (NSError *)errorSavingMoreThanSixPokemons
{
    return [NSError errorWithDomain:PKEErrorPokemonDomain
                               code:kPKEErrorCodeSavingMoreThanSixPokemons
                           userInfo:nil];
}

+ (NSError *)errorSavingSamePokemon
{
    return [NSError errorWithDomain:PKEErrorPokemonDomain
                               code:kPKEErrorCodeSavingSamePokemon
                           userInfo:nil];
}

+ (NSError *)errorSavingMoreThanFourMoves
{
    return [NSError errorWithDomain:PKEErrorMoveDomain
                               code:kPKEErrorCodeSavingMoreThanFourMoves
                           userInfo:nil];
}

+ (NSError *)errorSavingSameMove
{
    return [NSError errorWithDomain:PKEErrorMoveDomain
                               code:kPKEErrorCodeSavingSameMove
                           userInfo:nil];
}

@end
