//
//  PKEPartyViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPartyViewController.h"
#import "PKEDataBaseManager.h"
#import "PKEMemberCell.h"
#import "PKEPokemon.h"

@interface PKEPartyViewController ()

@property (nonatomic, strong) NSArray *dataSource;

- (void)addButtonTapped:(id)sender;
- (void)chartButtonTapped:(id)sender;

@end

@implementation PKEPartyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDataSource:[[PKEDataBaseManager sharedManager] getParty]];
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(addButtonTapped:)];
    UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Chart"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(chartButtonTapped:)];
    [self.navigationItem setRightBarButtonItems:@[searchBarButtonItem, filterBarButtonItem]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)addButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"AddSegue"
                              sender:self];
}

- (void)chartButtonTapped:(id)sender
{
    
}

- (void)configureTableViewCell:(PKEMemberCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEPokemon *pokemon = [[self dataSource] objectAtIndex:[indexPath row]];
    [[tableViewCell lblName] setText:[pokemon name]];
    [[tableViewCell imgPicture] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [pokemon number]]]];
    if ([[pokemon types] count] == 1) {
        [tableViewCell addBackgroundLayersWithColor:[[PKEDataBaseManager sharedManager] getColorForType:[[pokemon types] objectAtIndex:0]]];
    }
    else {
        [tableViewCell addBackgroundLayersWithFirstColor:[[PKEDataBaseManager sharedManager] getColorForType:[[pokemon types] objectAtIndex:0]]
                                             secondColor:[[PKEDataBaseManager sharedManager] getColorForType:[[pokemon types] objectAtIndex:1]]];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MemberCell";
    PKEMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                    forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

@end
