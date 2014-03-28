//
//  NSError+PokemonError.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "NSError+PKEPokemonError.h"

NSString * const PKEErrorPokemonDomain = @"PKEErrorPokemonDomain";
NSString * const PKEErrorMoveDomain = @"PKEErrorMoveDomain";

@implementation NSError (PKEPokemonError)

+ (NSError *)PKE_errorSavingMoreThanSixPokemons
{
    return [NSError errorWithDomain:PKEErrorPokemonDomain
                               code:kPKEErrorCodeSavingMoreThanSixPokemons
                           userInfo:nil];
}

+ (NSError *)PKE_errorSavingSamePokemon
{
    return [NSError errorWithDomain:PKEErrorPokemonDomain
                               code:kPKEErrorCodeSavingSamePokemon
                           userInfo:nil];
}

+ (NSError *)PKE_errorSavingMoreThanFourMoves
{
    return [NSError errorWithDomain:PKEErrorMoveDomain
                               code:kPKEErrorCodeSavingMoreThanFourMoves
                           userInfo:nil];
}

+ (NSError *)PKE_errorSavingSameMove
{
    return [NSError errorWithDomain:PKEErrorMoveDomain
                               code:kPKEErrorCodeSavingSameMove
                           userInfo:nil];
}

@end
