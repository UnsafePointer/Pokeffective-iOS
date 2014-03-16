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
    BOOL isSelected = NO;
    switch ([self filterType]) {
        case kPKEFilerTypePokemon:
            isSelected = [[PKEPokemonManager sharedManager] filteringPokemonType] != PKEPokemonTypeNone;
            break;
        case kPKEFilerTypeMoves:
            isSelected = [[PKEPokemonManager sharedManager] filteringMoveType] != PKEPokemonTypeNone;
            break;
    }
    if (isSelected) {
        PKEPokemonType pokemonType = PKEPokemonTypeNone;
        switch ([self filterType]) {
            case kPKEFilerTypePokemon:
                pokemonType = [[PKEPokemonManager sharedManager] filteringPokemonType];
                break;
            case kPKEFilerTypeMoves:
                pokemonType = [[PKEPokemonManager sharedManager] filteringMoveType];
                break;
        }
        [[self collectionView] selectItemAtIndexPath:[NSIndexPath indexPathForItem:pokemonType - 1
                                                                         inSection:0]
                                            animated:YES
                                      scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
    else {
        NSMutableArray *barButtoms = [[[self navigationItem] rightBarButtonItems] mutableCopy];
        [barButtoms removeObject:[self clearButton]];
        [[self navigationItem] setRightBarButtonItems:[barButtoms copy]];
    }
}

#pragma mark - Public Methods

- (IBAction)clearButtonTapped:(id)sender
{
    switch ([self filterType]) {
        case kPKEFilerTypePokemon:
            [[PKEPokemonManager sharedManager] setFilteringPokemonType:PKEPokemonTypeNone];
            break;
        case kPKEFilerTypeMoves:
            [[PKEPokemonManager sharedManager] setFilteringMoveType:PKEPokemonTypeNone];
            break;
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
    switch ([self filterType]) {
        case kPKEFilerTypePokemon:
            [[PKEPokemonManager sharedManager] setFilteringPokemonType:[indexPath row] + 1];
            break;
        case kPKEFilerTypeMoves:
            [[PKEPokemonManager sharedManager] setFilteringMoveType:[indexPath row] + 1];
            break;
    }
    [[self navigationController] popViewControllerAnimated:YES];
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
