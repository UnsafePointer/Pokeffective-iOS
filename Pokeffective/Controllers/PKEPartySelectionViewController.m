//
//  PKEPartySelectionViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 30/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPartySelectionViewController.h"
#import "PKEPartyCollectionViewFlowLayout.h"
#import "PKEPokemon.h"
#import "PKEPartySelectionCollectionViewCell.h"
#import "PKEPokemonManager.h"
#import "PKEMove.h"

@interface PKEPartySelectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

- (void)filterDataSource;
- (void)configureCollectionView;
- (void)configureTableViewCell:(PKEPartySelectionCollectionViewCell *)collectionViewCell
                  forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PKEPartySelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self filterDataSource];
    [self configureCollectionView];
    UINib *nib = [UINib nibWithNibName:@"PKEPartySelectionCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [[self collectionView] registerNib:nib
            forCellWithReuseIdentifier:@"PartySelectionCollectionViewCell"];
}

#pragma mark - Private Methods

- (void)filterDataSource
{
    NSMutableArray *dataSource = [NSMutableArray array];
    for (PKEPokemon *pokemon in [self box]) {
        if ([[pokemon moves] count] >= 4) {
            [dataSource addObject:pokemon];
        }
    }
    [self setDataSource:[dataSource copy]];
}

- (void)configureCollectionView
{
    PKEPartyCollectionViewFlowLayout *layout = [[PKEPartyCollectionViewFlowLayout alloc] initWithCoder:nil];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [[self view] addSubview:collectionView];
    [collectionView setAllowsMultipleSelection:YES];
    [self setCollectionView:collectionView];
}

- (void)configureTableViewCell:(PKEPartySelectionCollectionViewCell *)collectionViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[collectionViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEPokemon *pokemon = [[self dataSource] objectAtIndex:[indexPath row]];
    NSArray *labels = @[[collectionViewCell lblFirstMove], [collectionViewCell lblSecondMove], [collectionViewCell lblThirdMove], [collectionViewCell lblFourthMove]];
    int i = 0;
    for (PKEMove *move in [pokemon moves]) {
        UILabel *label = labels[i];
        [label setText:[move name]];
        i++;
    }
    [[collectionViewCell imgPicture] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d.png", [pokemon identifier]]]];
    if ([pokemon secondType] == PKEPokemonTypeNone) {
        [collectionViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]];
    }
    else {
        [collectionViewCell addBackgroundLayersWithFirstColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]
                                             secondColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon secondType]]];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PartySelectionCollectionViewCell";
    PKEPartySelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                  forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

@end
