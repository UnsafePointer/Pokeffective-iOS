//
//  PKESTAB.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKEPokemon;
@class PKEMove;

@interface PKESTAB : NSObject

@property (nonatomic, strong) PKEPokemon *pokemon;
@property (nonatomic, strong) NSArray *moves;

@end
