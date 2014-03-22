//
//  PKEEffectiveViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEEffectiveViewController.h"
#import "PKEEffectiveCollectionViewCell.h"
#import "PKEPokemonManager.h"
#import "PKEEffective.h"

@interface PKEEffectiveViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation PKEEffectiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD show];
    [[PKEPokemonManager sharedManager] calculatePokeffectiveWithParty:[self party]
                                                           completion:^(NSArray *array, NSError *error) {
                                                               @weakify(self);
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   @strongify(self);
                                                                   [SVProgressHUD dismiss];
                                                                   if (!error) {
                                                                       [self setDataSource:array];
                                                                       [[self collectionView] reloadData];
                                                                   }
                                                               });
                                                           }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"EffectiveCollectionViewCell";
    PKEEffectiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                     forIndexPath:indexPath];
    [self configureCollectionViewCell:cell
                         forIndexPath:indexPath];
    return cell;
}

#pragma mark - Private Methods

- (void)configureCollectionViewCell:(PKEEffectiveCollectionViewCell *)collectionViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    PKEEffective *effective = [[self dataSource] objectAtIndex:[indexPath row]];
    [[collectionViewCell lblType] setText:[[PKEPokemonManager sharedManager] nameForType:[effective pokemonType]]];
    [[collectionViewCell lblEffective] setText:[[PKEPokemonManager sharedManager] nameForEffectiveness:[effective effectiveness]]];
    [collectionViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[effective pokemonType]]];
}

@end
