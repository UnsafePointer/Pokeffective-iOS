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
#import "PKESTABsViewController.h"

@interface PKEEffectiveViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation PKEEffectiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD show];
    [[PKEPokemonManager sharedManager] calculatePokeffectiveWithParty:[self party]
                                                              andType:[self analysisType]
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"STABsSegue"]) {
        PKEEffective *effective = [[self dataSource] objectAtIndex:[[[[self collectionView] indexPathsForSelectedItems] firstObject] row]];
        PKESTABsViewController *controller = [segue destinationViewController];
        controller.dataSource = [effective STABs];
    }
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

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"STABsSegue"
                              sender:self];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PKEEffective *effective = [[self dataSource] objectAtIndex:[indexPath row]];
    if ([[effective STABs] count] > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods

- (void)configureCollectionViewCell:(PKEEffectiveCollectionViewCell *)collectionViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    PKEEffective *effective = [[self dataSource] objectAtIndex:[indexPath row]];
    [[collectionViewCell lblType] setText:[[PKEPokemonManager sharedManager] nameForType:[effective pokemonType]]];
    [[collectionViewCell lblEffective] setText:[[PKEPokemonManager sharedManager] nameForEffectiveness:[effective effectiveness]]];
    if ([[effective STABs] count] > 0) {
        [[collectionViewCell imgViewDisclosure] setHidden:NO];
    }
    else {
        [[collectionViewCell imgViewDisclosure] setHidden:YES];
    }
    [collectionViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[effective pokemonType]]];
}

@end
