//
//  PKETypeViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKETypeViewController.h"
#import "PKETypeCell.h"
#import "PKEPokemonManager.h"

@interface PKETypeViewController ()

@end

@implementation PKETypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self collectionView] setAllowsMultipleSelection:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self pokemonTypeFiltered] != PKEPokemonTypeNone) {
        [[self collectionView] selectItemAtIndexPath:[[PKEPokemonManager sharedManager] indexPathForPokemonType:[self pokemonTypeFiltered]]
                                            animated:YES
                                      scrollPosition:UICollectionViewScrollPositionNone];
    }
    else {
        NSMutableArray *barButtoms = [[[self navigationItem] rightBarButtonItems] mutableCopy];
        [barButtoms removeObject:[self clearButton]];
        [[self navigationItem] setRightBarButtonItems:[barButtoms copy] animated:YES];
    }
}

#pragma mark - Public Methods

- (IBAction)clearButtonTapped:(id)sender
{
    if ([[self delegate] respondsToSelector:@selector(onSelectPokemonType:)]) {
        [[self delegate] onSelectPokemonType:PKEPokemonTypeNone];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return TOTAL_POKEMON_TYPES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TypeCell";
    PKETypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                  forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self delegate] respondsToSelector:@selector(onSelectPokemonType:)]) {
        PKEPokemonType selectedPokemonType = [[PKEPokemonManager sharedManager] pokemonTypeForIndexPath:indexPath];
        [[self delegate] onSelectPokemonType:selectedPokemonType];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self pokemonTypeFiltered] == [[PKEPokemonManager sharedManager] pokemonTypeForIndexPath:indexPath]) {
        [[self navigationItem] setRightBarButtonItems:nil animated:YES];
        if ([[self delegate] respondsToSelector:@selector(onSelectPokemonType:)]) {
            [[self delegate] onSelectPokemonType:PKEPokemonTypeNone];
        }
    }
}

#pragma mark - Private Methods

- (void)configureTableViewCell:(PKETypeCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    [[tableViewCell lblName] setText:[[PKEPokemonManager sharedManager] nameForType:[indexPath row] + 1]];
    [tableViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[indexPath row] + 1]];
}

@end
