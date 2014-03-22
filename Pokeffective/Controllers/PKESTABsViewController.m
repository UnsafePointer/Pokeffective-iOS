//
//  PKESTABersViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKESTABsViewController.h"
#import "PKESTABCollectionViewCell.h"
#import "PKESTAB.h"
#import "PKEPokemon.h"
#import "PKEMove.h"
#import "PKEPokemonManager.h"

@interface PKESTABsViewController ()

@end

@implementation PKESTABsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"STABCollectionViewCell";
    PKESTABCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                  forIndexPath:indexPath];
    [self configureCollectionViewCell:cell
                         forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Private Methods

- (void)configureCollectionViewCell:(PKESTABCollectionViewCell *)collectionViewCell
                       forIndexPath:(NSIndexPath *)indexPath
{
    PKESTAB *STAB = [[self dataSource] objectAtIndex:[indexPath row]];
    [[collectionViewCell lblPokemonName] setText:[[STAB pokemon] name]];
    NSString *moveName = [[[STAB move] name] lowercaseString];
    moveName = [moveName stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    [[collectionViewCell lblMoveName] setText:[moveName capitalizedString]];
    [collectionViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[[STAB move] type]]];
}

@end
