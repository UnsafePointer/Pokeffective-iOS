//
//  NSError+PokemonError.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "NSError+PokemonError.h"

NSString * const PKEErrorDomain = @"PKEErrorDomain";

@implementation NSError (PokemonError)

+ (NSError *)errorSavingMoreThanSixPokemons
{
    return [NSError errorWithDomain:PKEErrorDomain
                               code:kPKEErrorCodeSavingMoreThanSixPokemons
                           userInfo:nil];
}

+ (NSError *)errorSavingSamePokemon
{
    return [NSError errorWithDomain:PKEErrorDomain
                               code:kPKEErrorCodeSavingSamePokemon
                           userInfo:nil];
}

@end
