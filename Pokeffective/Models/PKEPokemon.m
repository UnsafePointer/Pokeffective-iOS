//
//  PKEPokemon.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPokemon.h"

@implementation PKEPokemon

+ (PKEPokemon *)createPokemonWithDictionary:(NSDictionary *)dictionary;
{
    PKEPokemon *pokemon = [PKEPokemon new];
    [pokemon setIdentifier:[dictionary objectForKey:@"Identifier"]];
    [pokemon setName:[dictionary objectForKey:@"Name"]];
    [pokemon setNumber:[dictionary objectForKey:@"Number"]];
    [pokemon setTypes:[dictionary objectForKey:@"Types"]];
    return pokemon;
}

@end
