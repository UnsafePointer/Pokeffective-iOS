//
//  PKECoreDataHelper.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKEPokemon;
@class PKEMove;

@interface PKECoreDataHelper : NSObject

- (void)addPokemonToBox:(PKEPokemon *)pokemon
             completion:(BooleanCompletionBlock)completionBlock;
- (void)removePokemonFromBox:(PKEPokemon *)pokemon
                  completion:(BooleanCompletionBlock)completionBlock;
- (void)getBoxWithCompletion:(ArrayCompletionBlock)completionBlock;
- (void)addMove:(PKEMove *)move
      toPokemon:(PKEPokemon *)pokemon
     completion:(BooleanCompletionBlock)completionBlock;
- (void)removeMove:(PKEMove *)move
         toPokemon:(PKEPokemon *)pokemon
        completion:(BooleanCompletionBlock)completionBlock;

@end
