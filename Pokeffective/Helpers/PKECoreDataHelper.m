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
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSError *error;
        [MTLManagedObjectAdapter managedObjectFromModel:pokemon
                                   insertingIntoContext:localContext
                                                  error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    } completion:^(BOOL success, NSError *error) {
        if (completionBlock) {
            completionBlock(success, error);
        }
    }];
}

- (void)removePokemonFromParty:(PKEPokemon *)pokemon
                    completion:(BooleanCompletionBlock)completionBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        PKEPokemonManagedObject *pokemonManagedObject =
        [PKEPokemonManagedObject MR_findFirstByAttribute:@"identifier"
                                               withValue:[NSNumber numberWithInt:pokemon.identifier]
                                               inContext:localContext];
        [pokemonManagedObject MR_deleteInContext:localContext];
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
