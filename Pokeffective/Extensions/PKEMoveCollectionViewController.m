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
#import "PKELabel.h"
#import "PKEMoveCollectionViewFlow.h"

@interface PKEMoveCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)configureNoContentLabel;
- (void)configureCollectionView;
- (void)configureCollectionViewCell:(PKEMoveCollectionViewCell *)collectionViewCell
                       forIndexPath:(NSIndexPath *)indexPath
                   inCollectionView:(UICollectionView *)collectionView;

@end

@implementation PKEMoveCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureNoContentLabel];
    [self setTitle:[[self pokemon] name]];
    UINib *nib = [UINib nibWithNibName:@"PKEMoveCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [[self collectionView] registerNib:nib
            forCellWithReuseIdentifier:@"MoveCollectionViewCell"];
}

#pragma mark - Private Methods

- (void)configureNoContentLabel
{
    PKELabel *lblNoContent = [[PKELabel alloc] initWithFrame:self.view.bounds
                                               andEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 50)];
    [lblNoContent setNumberOfLines:0];
    [lblNoContent setTextAlignment:NSTextAlignmentCenter];
    [lblNoContent setTextColor:[UIColor colorWithHexString:@"#898C90"]];
    [lblNoContent setAlpha:0.0f];
    [[self view] addSubview:lblNoContent];
    [self setLblNoContent:lblNoContent];
}

- (void)configureCollectionView
{
    PKEMoveCollectionViewFlow *layout = [[PKEMoveCollectionViewFlow alloc] initWithCoder:nil];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [[self view] addSubview:collectionView];
    [self setCollectionView:collectionView];
}

- (void)configureCollectionViewCell:(PKEMoveCollectionViewCell *)collectionViewCell
                       forIndexPath:(NSIndexPath *)indexPath
                   inCollectionView:(UICollectionView *)collectionView
{
    [[collectionViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEMove *move = [self getMoveForIndexPath:indexPath
                             inCollectionView:collectionView];
    NSString *moveName = [[move name] lowercaseString];
    moveName = [moveName stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    [[collectionViewCell lblName] setText:[moveName capitalizedString]];
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
