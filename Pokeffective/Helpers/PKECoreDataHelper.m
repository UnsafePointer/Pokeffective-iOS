//
//  PKECoreDataHelper.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKECoreDataHelper.h"
#import "NSManagedObjectContext+BackgroundFetch.h"
#import "PKEPokemon.h"
#import "PKETranslatorHelper.h"
#import "PKEPokemonManagedObject.h"
#import "NSError+PokemonError.h"
#import "PKEMove.h"
#import "PKEMoveManagedObject.h"

@interface PKECoreDataHelper ()

@property (nonatomic, strong) PKETranslatorHelper *translatorHelper;

- (NSFetchRequest *)backgroundFetchRequestForEntityName:(NSString *)entityName
                                  withSortDescriptorKey:(NSString *)sortDescriptorKey
                                              ascending:(BOOL)ascending
                                           andPredicate:(NSPredicate *)predicate;

@end

@implementation PKECoreDataHelper
{
}

#pragma mark - Private Methods

- (PKETranslatorHelper *)translatorHelper
{
    if (_translatorHelper == nil) {
        _translatorHelper = [PKETranslatorHelper new];
    }
    return _translatorHelper;
}

- (NSFetchRequest *)backgroundFetchRequestForEntityName:(NSString *)entityName
                                  withSortDescriptorKey:(NSString *)sortDescriptorKey
                                              ascending:(BOOL)ascending
                                           andPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.includesPropertyValues = NO;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortDescriptorKey
                                                                   ascending:ascending];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    return fetchRequest;
}

#pragma mark - Public Methods

- (void)addPokemonToParty:(PKEPokemon *)pokemon
               completion:(BooleanCompletionBlock)completionBlock;
{
    __block NSError *pokemonError;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *storedParty = [PKEPokemonManagedObject MR_findAllInContext:localContext];
        BOOL shouldSave = YES;
        if ([storedParty count] > 6) {
            pokemonError = [NSError errorSavingMoreThanSixPokemons];
            shouldSave = NO;
        }
        else {
            for (PKEPokemonManagedObject *pokemonManagedObject in storedParty) {
                if ([[pokemonManagedObject identifier] unsignedIntegerValue] == [pokemon identifier]) {
                    pokemonError = [NSError errorSavingSamePokemon];
                    shouldSave = NO;
                }
            }
        }
        if (shouldSave) {
            NSError *error;
            [MTLManagedObjectAdapter managedObjectFromModel:pokemon
                                       insertingIntoContext:localContext
                                                      error:&error];
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }
    } completion:^(BOOL success, NSError *error) {
        if (completionBlock) {
            if (!success) {
                completionBlock(success, pokemonError);
            }
            else {
                completionBlock(success, error);
            }
        }
    }];
}

- (void)addMove:(PKEMove *)move
      toPokemon:(PKEPokemon *)pokemon
     completion:(BooleanCompletionBlock)completionBlock
{
    __block NSError *pokemonError;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        PKEPokemonManagedObject *pokemonManagedObject = [PKEPokemonManagedObject MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"identifier == %d", pokemon.identifier]
                                                                                                 inContext:localContext];
        NSArray *storedMoves = [PKEMoveManagedObject MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"pokemon == %@", pokemonManagedObject]
                                                                   inContext:localContext];
        BOOL shouldSave = YES;
        if ([storedMoves count] > 4) {
            pokemonError = [NSError errorSavingMoreThanFourMoves];
            shouldSave = NO;
        }
        else {
            for (PKEMoveManagedObject *moveManagedObject in storedMoves) {
                if ([[moveManagedObject name] isEqualToString:[move name]]) {
                    pokemonError = [NSError errorSavingSameMove];
                    shouldSave = NO;
                }
            }
        }
        if (shouldSave) {
            NSError *error;
            PKEMoveManagedObject *moveManagedObject = [MTLManagedObjectAdapter managedObjectFromModel:move
                                                                                 insertingIntoContext:localContext
                                                                                                error:&error];
            [pokemonManagedObject addMovesObject:moveManagedObject];
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }
    } completion:^(BOOL success, NSError *error) {
        if (completionBlock) {
            if (!success) {
                completionBlock(success, pokemonError);
            }
            else {
                completionBlock(success, error);
            }
        }
    }];
}

- (void)removePokemonFromParty:(PKEPokemon *)pokemon
                    completion:(BooleanCompletionBlock)completionBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        PKEPokemonManagedObject *pokemonManagedObject =
        [PKEPokemonManagedObject MR_findFirstByAttribute:@"identifier"
                                               withValue:[NSNumber numberWithUnsignedInteger:pokemon.identifier]
                                               inContext:localContext];
        [pokemonManagedObject MR_deleteInContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        if (completionBlock) {
            completionBlock(success, error);
        }
    }];
}

- (void)removeMove:(PKEMove *)move
         toPokemon:(PKEPokemon *)pokemon
        completion:(BooleanCompletionBlock)completionBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        PKEPokemonManagedObject *pokemonManagedObject =
        [PKEPokemonManagedObject MR_findFirstByAttribute:@"identifier"
                                               withValue:[NSNumber numberWithUnsignedInteger:pokemon.identifier]
                                               inContext:localContext];
        PKEMoveManagedObject *moveManagedObject =
        [PKEMoveManagedObject MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"pokemon == %@ and name ==%@", pokemonManagedObject, [move name]]
                                              inContext:localContext];
        [moveManagedObject MR_deleteInContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        if (completionBlock) {
            completionBlock(success, error);
        }
    }];
}

- (void)getPartyWithCompletion:(ArrayCompletionBlock)completionBlock
{
    NSFetchRequest *fetchRequest = [self backgroundFetchRequestForEntityName:@"PKEPokemonManagedObject"
                                                       withSortDescriptorKey:@"identifier"
                                                                   ascending:YES
                                                                andPredicate:nil];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    [context executeFetchRequest:fetchRequest
                      completion:^(NSArray *array, NSError *error) {
                          
                          if (array) {
                              if (completionBlock) {
                                  completionBlock([[self translatorHelper]
                                                   translateCollectionfromManagedObjects:array
                                                   withClass:[PKEPokemon class]], nil);
                              }
                          }
                          else {
                              if (completionBlock) {
                                  completionBlock(nil, error);
                              }
                          }
                      }];
}

@end
