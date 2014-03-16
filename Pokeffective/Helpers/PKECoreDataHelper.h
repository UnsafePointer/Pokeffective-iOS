//
//  PKECoreDataHelper.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKEPokemon;

@interface PKECoreDataHelper : NSObject

- (void)addPokemonToParty:(PKEPokemon *)pokemon
               completion:(BooleanCompletionBlock)completionBlock;
- (void)getPartyWithCompletion:(ArrayCompletionBlock)completionBlock;

@end
