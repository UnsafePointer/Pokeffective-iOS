//
//  Includes.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 15/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PKEPokemonType) {
    PKEPokemonTypeNone,
    PKEPokemonTypeNormal,
    PKEPokemonTypeFighting,
    PKEPokemonTypeFlying,
    PKEPokemonTypePoison,
    PKEPokemonTypeGround,
    PKEPokemonTypeRock,
    PKEPokemonTypeBug,
    PKEPokemonTypeGhost,
    PKEPokemonTypeSteel,
    PKEPokemonTypeFire,
    PKEPokemonTypeWater,
    PKEPokemonTypeGrass,
    PKEPokemonTypeElectric,
    PKEPokemonTypePsychic,
    PKEPokemonTypeIce,
    PKEPokemonTypeDragon,
    PKEPokemonTypeDark,
    PKEPokemonTypeFairy
};

typedef NS_ENUM(NSUInteger, PKEMoveCategory) {
    PKEMoveCategoryAll,
    PKEMoveCategoryNonDamaging,
    PKEMoveCategoryPhysical,
    PKEMoveCategorySpecial
};

typedef NS_ENUM(NSUInteger, PKEMoveMethod) {
    PKEMoveMethodAll,
    PKEMoveMethodLevelUp,
    PKEMoveMethodEgg,
    PKEMoveMethodTutor,
    PKEMoveMethodMachine
};

typedef NS_ENUM(NSUInteger, PKEPokedexType) {
    PKEPokedexTypeNone,
    PKEPokedexTypeNational,
    PKEPokedexTypeKanto,
    PKEPokedexTypeJohto,
    PKEPokedexTypeHoenn,
    PKEPokedexTypeOriginalSinnoh,
    PKEPokedexTypeExtendedSinnoh,
    PKEPokedexTypeUpdatedJohto,
    PKEPokedexTypeOriginalUnova,
    PKEPokedexTypeExtendedUnova,
    PKEPokedexTypeConquestGallery,
    PKEPokedexTypeKalosCentral,
    PKEPokedexTypeKalosCoastal,
    PKEPokedexTypeKalosMountain,
};

typedef NS_ENUM(NSInteger, PKEErrorCodePokemon) {
    kPKEErrorCodeSavingSamePokemon
};

typedef NS_ENUM(NSInteger, PKEErrorCodeMove) {
    kPKEErrorCodeSavingSameMove
};

typedef NS_ENUM(NSInteger, PKEFilerType) {
    kPKEFilerTypePokemon,
    kPKEFilerTypeMoves
};

typedef NS_ENUM(NSInteger, PKEEffectiveness) {
    PKEEffectivenessNoEffect = 0,
    PKEEffectivenessNotVeryEffective = 50,
    PKEEffectivenessNormal = 100,
    PKEEffectivenessSuperEffective = 200
};

#define FIRST_TYPE_SLOT 1
#define SECOND_TYPE_SLOT 2
#define TOTAL_POKEMON_TYPES 18
#define MAX_POKEMON_PARTY 3
#define MAX_POKEMON_MOVES 4
#define IAP_IDENTIFIER @"com.ruenzuo.Pokeffective.Storage"
#define EMPTY_RESULTS @"No results for this filter values. Please, try others."
#define EMPTY_PARTY @"No pokemon added to the party found. Add one to get started.\nYou can remove them later holding the cells."
#define EMPTY_MOVESET @"No move added to moveset found. Add one to get started.\nYou can remove them later holding the cells."