//
//  PKEQueryHelper.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 15/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEQueryHelper.h"

@implementation PKEQueryHelper

- (NSString *)pokemonSearchQueryFilterByPokedexType:(PKEPokedexType)pokedexType
                                        pokemonType:(PKEPokemonType)pokemonType
                                           typeSlot:(NSUInteger)typeSlot
{
    if (pokemonType != PKEPokemonTypeNone) {
        return [NSString stringWithFormat:@"select po.id as identifier, "
                "  ps.identifier as name, "
                "  pdn.pokedex_number as number, "
                "  pt.type_id as type "
                "from pokemon_species as ps "
                "  join pokemon_dex_numbers as pdn "
                "    on ps.id = pdn.species_id "
                "  join pokemon as po "
                "    on ps.id = po.species_id "
                "  join pokemon_types as pt "
                "    on po.id = pt.pokemon_id "
                "where pdn.pokedex_id = %d and "
                "  pt.type_id = %d and "
                "  pt.slot = %d "
                "order by pdn.pokedex_number ", pokedexType, pokemonType, typeSlot];
    }
    else {
        return [NSString stringWithFormat:@"select po.id as identifier, "
                "  ps.identifier as name, "
                "  pdn.pokedex_number as number, "
                "  pt.type_id as type "
                "from pokemon_species as ps "
                "  join pokemon_dex_numbers as pdn "
                "    on ps.id = pdn.species_id "
                "  join pokemon as po "
                "    on ps.id = po.species_id "
                "  join pokemon_types as pt "
                "    on po.id = pt.pokemon_id "
                "where pdn.pokedex_id = %d and "
                "  pt.slot = %d "
                "order by pdn.pokedex_number ", pokedexType, typeSlot];
    }
}

- (NSString *)pokemonTypeQueryByIdentifier:(NSUInteger)identifier
                                  typeSlot:(NSUInteger)typeSlot
{
    return [NSString stringWithFormat:@"select po.id as identifier, "
            "  ps.identifier as name, "
            "  pt.type_id as type "
            "from pokemon_species as ps "
            "  join pokemon as po "
            "    on ps.id = po.species_id "
            "  join pokemon_types as pt "
            "    on po.id = pt.pokemon_id "
            "where po.id = %d and "
            "  pt.slot = %d", identifier, typeSlot];
}

@end
