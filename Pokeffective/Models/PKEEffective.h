//
//  PKEEffective.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKEEffective : NSObject

@property (nonatomic, assign) PKEPokemonType pokemonType;
@property (nonatomic, assign) PKEEffectiveness effectiveness;
@property (nonatomic, strong) NSArray *STABers;

@end
