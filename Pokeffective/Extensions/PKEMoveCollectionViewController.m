//
//  PKEMoveCollectionViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEMoveCollectionViewController.h"
#import "PKEMoveCollectionViewCell.h"
#import "PKEPokemon.h"
#import "PKEMove.h"
#import "PKEPokemonManager.h"

@interface PKEMoveCollectionViewController ()

- (void)configureCollectionViewCell:(PKEMoveCollectionViewCell *)collectionViewCell
                       forIndexPath:(NSIndexPath *)indexPath
                   inCollectionView:(UICollectionView *)collectionView;

@end

@implementation PKEMoveCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[[self pokemon] name]];
    UINib *nib = [UINib nibWithNibName:@"PKEMoveCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [[self collectionView] registerNib:nib
            forCellWithReuseIdentifier:@"MoveCollectionViewCell"];
}

#pragma mark - Private Methods

- (void)configureCollectionViewCell:(PKEMoveCollectionViewCell *)collectionViewCell
                       forIndexPath:(NSIndexPath *)indexPath
                   inCollectionView:(UICollectionView *)collectionView
{
    [[collectionViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEMove *move = [self getMoveForIndexPath:indexPath
                             inCollectionView:collectionView];
    [[collectionViewCell lblName] setText:[move name]];
    [[collectionViewCell lblCategory] setText:[[PKEPokemonManager sharedManager] nameForCategory:[move category]]];
    [[collectionViewCell lblPower] setText:[NSString stringWithFormat:@"Pwr: %d", [move power]]];
    if ([move accuracy] == 0) {
        [[collectionViewCell lblAccuracy] setText:@"Acc: 100%"];
    }
    else {
        [[collectionViewCell lblAccuracy] setText:[NSString stringWithFormat:@"Acc: %d%%", [move accuracy]]];
    }
    [collectionViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[move type]]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoveCollectionViewCell";
    PKEMoveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
    [self configureCollectionViewCell:cell
                         forIndexPath:indexPath
                     inCollectionView:collectionView];
    return cell;
}

#pragma mark - PKEMoveCollectionViewControllerDataSource

- (PKEMove *)getMoveForIndexPath:(NSIndexPath *)indexPath
                inCollectionView:(UICollectionView *)collectionView
{
    return [[self dataSource] objectAtIndex:[indexPath row]];
}

@end
