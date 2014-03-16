//
//  PKEPartyViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPartyViewController.h"
#import "PKEPokemonManager.h"
#import "PKEMemberCell.h"
#import "PKEPokemon.h"
#import "PKEMovesetViewController.h"
#import "PKETableViewController.h"

@interface PKEPartyViewController () <PKETableViewControllerDelegate>

@property (nonatomic, strong) NSArray *dataSource;

- (void)addButtonTapped:(id)sender;
- (void)chartButtonTapped:(id)sender;

@end

@implementation PKEPartyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(addButtonTapped:)];
    UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Chart"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(chartButtonTapped:)];
    [self.navigationItem setRightBarButtonItems:@[searchBarButtonItem, filterBarButtonItem]];
    @weakify(self)
    [[PKEPokemonManager sharedManager] getPartyWithCompletion:^(NSArray *array, NSError *error) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
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
    if ([[segue identifier] isEqualToString:@"MovesetSegue"]) {
        PKEMovesetViewController *controller = [segue destinationViewController];
        NSArray *selectedIndexPaths = [[self collectionView] indexPathsForSelectedItems];
        NSIndexPath *selectedIndesPath = [selectedIndexPaths objectAtIndex:0];
        PKEPokemon *selectedPKMN = [[self dataSource] objectAtIndex:[selectedIndesPath row]];
        controller.pokemon = selectedPKMN;
    }
    if ([[segue identifier] isEqualToString:@"AddSegue"]) {
        PKETableViewController *controller = [segue destinationViewController];
        [controller setDelegate:self];
    }
}

#pragma mark - Private Methods

- (void)addButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"AddSegue"
                              sender:self];
}

- (void)chartButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"EffectiveSegue"
                              sender:self];
}

- (void)configureTableViewCell:(PKEMemberCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEPokemon *pokemon = [[self dataSource] objectAtIndex:[indexPath row]];
    [[tableViewCell lblName] setText:[pokemon name]];
    [[tableViewCell imgPicture] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d.png", [pokemon identifier]]]];
    if ([pokemon secondType] == PKEPokemonTypeNone) {
        [tableViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]];
    }
    else {
        [tableViewCell addBackgroundLayersWithFirstColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]
                                             secondColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon secondType]]];
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

#pragma mark - PKETableViewControllerDelegate

- (void)tableViewControllerDidSelectPokemon:(PKEPokemon *)pokemon
                                      error:(NSError *)error
{
    if (!error) {
        NSMutableArray *mutableDataSource = [[self dataSource] mutableCopy];
        [mutableDataSource addObject:pokemon];
        [self setDataSource:mutableDataSource];
        [[self collectionView] reloadData];
    }
}

@end
