//
//  PKEMoveListViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEMoveListViewController.h"
#import "PKEPokemonManager.h"
#import "PKEMoveSearchViewController.h"
#import "PKEFilterViewController.h"
#import "PKEMoveCollectionViewCell.h"
#import "PKEMove.h"

@interface PKEMoveListViewController () <PKEMoveTableViewControllerDataSource>

@property (nonatomic, strong) NSArray *dataSource;

- (void)searchButtonTapped:(id)sender;
- (void)filterButtonTapped:(id)sender;

- (void)configureCollectionViewCell:(PKEMoveCollectionViewCell *)collectionViewCell
                       forIndexPath:(NSIndexPath *)indexPath;

@end

static void * PKEMoveListViewControllerContext = &PKEMoveListViewControllerContext;

@implementation PKEMoveListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"PKEMoveCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [[self collectionView] registerNib:nib
            forCellWithReuseIdentifier:@"MoveCollectionViewCell"];
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(searchButtonTapped:)];
    UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Filter"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(filterButtonTapped:)];
    [self.navigationItem setRightBarButtonItems:@[searchBarButtonItem, filterBarButtonItem]];
    [[PKEPokemonManager sharedManager] addObserver:self
                                        forKeyPath:NSStringFromSelector(@selector(filteringMoveMethod))
                                           options:NSKeyValueObservingOptionNew
                                           context:PKEMoveListViewControllerContext];
    [[PKEPokemonManager sharedManager] addObserver:self
                                        forKeyPath:NSStringFromSelector(@selector(filteringMoveType))
                                           options:NSKeyValueObservingOptionNew
                                           context:PKEMoveListViewControllerContext];
    [[PKEPokemonManager sharedManager] addObserver:self
                                        forKeyPath:NSStringFromSelector(@selector(filteringMoveCategory))
                                           options:NSKeyValueObservingOptionNew
                                           context:PKEMoveListViewControllerContext];
    [SVProgressHUD show];
    [[PKEPokemonManager sharedManager] getMovesForPokemon:[self pokemon]
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

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == PKEMoveListViewControllerContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(filteringMoveMethod))] ||
            [keyPath isEqualToString:NSStringFromSelector(@selector(filteringMoveType))] ||
            [keyPath isEqualToString:NSStringFromSelector(@selector(filteringMoveCategory))]) {
            [[PKEPokemonManager sharedManager] getMovesForPokemon:[self pokemon]
                                                       completion:^(NSArray *array, NSError *error) {
                                                           @weakify(self);
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               @strongify(self);
                                                               if (!error) {
                                                                   [self setDataSource:array];
                                                                   [[self collectionView] reloadData];
                                                               }
                                                           });
                                                       }];
        }
    }
}

- (void)dealloc
{
    [[PKEPokemonManager sharedManager] removeObserver:self
                                           forKeyPath:NSStringFromSelector(@selector(filteringMoveMethod))];
    [[PKEPokemonManager sharedManager] removeObserver:self
                                           forKeyPath:NSStringFromSelector(@selector(filteringMoveType))];
    [[PKEPokemonManager sharedManager] removeObserver:self
                                           forKeyPath:NSStringFromSelector(@selector(filteringMoveCategory))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        PKEMoveSearchViewController *searchViewController = [segue destinationViewController];
        searchViewController.delegate = self.delegate;
        searchViewController.pokemon = self.pokemon;
        [searchViewController setDataSource:[self dataSource]];
    }
    if ([[segue identifier] isEqualToString:@"FilterSegue"]) {
        PKEFilterViewController *filterViewController = [segue destinationViewController];
        filterViewController.filterType = kPKEFilerTypeMoves;
    }
}

#pragma mark - Private Methods

- (void)searchButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"SearchSegue"
                              sender:self];
}

- (void)filterButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"FilterSegue"
                              sender:self];
}

- (void)configureCollectionViewCell:(PKEMoveCollectionViewCell *)collectionViewCell
                       forIndexPath:(NSIndexPath *)indexPath;
{
    [[collectionViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEMove *move = [self getMoveForIndexPath:indexPath];
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
                         forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PKEMove *move = [self getMoveForIndexPath:indexPath];
    @weakify(self);
    [[PKEPokemonManager sharedManager] addMove:move
                                     toPokemon:[self pokemon]
                                    completion:^(BOOL result, NSError *error) {
                                        @strongify(self);
                                        if ([[self delegate] respondsToSelector:@selector(tableViewControllerDidSelectMove:error:)]) {
                                            [[self delegate] performSelector:@selector(tableViewControllerDidSelectMove:error:)
                                                                  withObject:[move copy]
                                                                  withObject:error];
                                        }
                                        NSArray *controllers = [[self navigationController] viewControllers];
                                        [[self navigationController] popToViewController:[controllers objectAtIndex:1]
                                                                                animated:YES];
                                    }];
}

#pragma mark - PKEMoveTableViewControllerDataSource

- (PKEMove *)getMoveForIndexPath:(NSIndexPath *)indexPath
{
    return [[self dataSource] objectAtIndex:[indexPath row]];
}

@end
