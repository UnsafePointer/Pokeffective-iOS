//
//  PKETypeHelper.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 15/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEFormatHelper.h"
#import <HexColors/HexColor.h>

@interface PKEFormatHelper ()

@property (nonatomic, strong) NSArray *colors;

@end

@implementation PKEFormatHelper
{
}

#pragma mark - Private Methods

- (NSArray *)colors
{
    if (_colors == nil) {
        _colors = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Types"
                                                                                   ofType:@"plist"]];
    }
    return _colors;
}

#pragma mark - Public Methods

- (UIColor *)colorForType:(PKEPokemonType)pokemonType
{
    NSString *color = [[self colors] objectAtIndex:(pokemonType - 1)];
    return [UIColor colorWithHexString:color];
}

- (NSString *)nameForType:(PKEPokemonType)pokemonType
{
    switch (pokemonType) {
        case PKEPokemonTypeNone:
            return @"None";
        case PKEPokemonTypeNormal:
            return @"Normal";
        case PKEPokemonTypeFighting:
            return @"Fighting";
        case PKEPokemonTypeFlying:
            return @"Flying";
        case PKEPokemonTypePoison:
            return @"Poison";
        case PKEPokemonTypeGround:
            return @"Ground";
        case PKEPokemonTypeRock:
            return @"Rock";
        case PKEPokemonTypeBug:
            return @"Bug";
        case PKEPokemonTypeGhost:
            return @"Ghost";
        case PKEPokemonTypeSteel:
            return @"Steel";
        case PKEPokemonTypeFire:
            return @"Fire";
        case PKEPokemonTypeWater:
            return @"Water";
        case PKEPokemonTypeGrass:
            return @"Grass";
        case PKEPokemonTypeElectric:
            return @"Electric";
        case PKEPokemonTypePsychic:
            return @"Psychic";
        case PKEPokemonTypeIce:
            return @"Ice";
        case PKEPokemonTypeDragon:
            return @"Dragon";
        case PKEPokemonTypeDark:
            return @"Dark";
        case PKEPokemonTypeFairy:
            return @"Fairy";
    }
}

- (PKEPokedexType)pokedexTypeForIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        return PKEPokedexTypeNational;
    }
    else if ([indexPath row] == 1) {
        return PKEPokedexTypeKanto;
    }
    else if ([indexPath row] == 2) {
        return PKEPokedexTypeJohto;
    }
    else if ([indexPath row] == 3) {
        return PKEPokedexTypeHoenn;
    }
    else if ([indexPath row] == 4) {
        return PKEPokedexTypeOriginalSinnoh;
    }
    else if ([indexPath row] == 5) {
        return PKEPokedexTypeOriginalUnova;
    }
    else if ([indexPath row] == 6) {
        return PKEPokedexTypeKalosCentral;
    }
    else if ([indexPath row] == 7) {
        return PKEPokedexTypeKalosCoastal;
    }
    else if ([indexPath row] == 8) {
        return PKEPokedexTypeKalosMountain;
    }
    return PKEPokedexTypeNone;
}

- (NSIndexPath *)indexPathForPokedexType:(PKEPokedexType)pokedexType
{
    if (pokedexType == PKEPokedexTypeNational) {
        return [NSIndexPath indexPathForRow:0
                                  inSection:0];
    }
    else if (pokedexType == PKEPokedexTypeKanto) {
        return [NSIndexPath indexPathForRow:1
                                  inSection:0];
    }
    else if (pokedexType == PKEPokedexTypeJohto) {
        return [NSIndexPath indexPathForRow:2
                                  inSection:0];
    }
    else if (pokedexType == PKEPokedexTypeHoenn) {
        return [NSIndexPath indexPathForRow:3
                                  inSection:0];
    }
    else if (pokedexType == PKEPokedexTypeOriginalSinnoh) {
        return [NSIndexPath indexPathForRow:4
                                  inSection:0];
    }
    else if (pokedexType == PKEPokedexTypeOriginalUnova) {
        return [NSIndexPath indexPathForRow:5
                                  inSection:0];
    }
    else if (pokedexType == PKEPokedexTypeKalosCentral) {
        return [NSIndexPath indexPathForRow:6
                                  inSection:0];
    }
    else if (pokedexType == PKEPokedexTypeKalosCoastal) {
        return [NSIndexPath indexPathForRow:7
                                  inSection:0];
    }
    else if (pokedexType == PKEPokedexTypeKalosMountain) {
        return [NSIndexPath indexPathForRow:8
                                  inSection:0];
    }
    return PKEPokedexTypeNone;
}

@end
