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
#import "PKELabel.h"
#import "TLAlertView.h"

@interface PKEMoveListViewController () <PKEMoveTableViewControllerDataSource>

- (void)searchButtonTapped:(id)sender;
- (void)filterButtonTapped:(id)sender;

@end

static void * PKEMoveListViewControllerContext = &PKEMoveListViewControllerContext;

@implementation PKEMoveListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self lblNoContent] setText:@"No results for this filter values. Please, try others."];
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
                                                       [self setDataSource:array];
                                                       if ([[self dataSource] count] == 0) {
                                                           [[self lblNoContent] setAlpha:1.0f];
                                                       }
                                                       else {
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
                                                               [self setDataSource:array];
                                                               [[self collectionView] reloadData];
                                                               if ([[self dataSource] count] == 0) {
                                                                   [[self lblNoContent] setAlpha:1.0f];
                                                               }
                                                               else {
                                                                   [[self lblNoContent] setAlpha:0.0f];
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
    if ([[self dataSource] count] > 0) {
        [self performSegueWithIdentifier:@"SearchSegue"
                                  sender:self];
    }
    else {
        TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please, try other filter values first."
                                                        buttonTitle:@"OK"];
        [alertView show];
    }
}

- (void)filterButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"FilterSegue"
                              sender:self];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PKEMove *move = [self getMoveForIndexPath:indexPath
                             inCollectionView:[self collectionView]];
    @weakify(self);
    [[PKEPokemonManager sharedManager] addMove:move
                                     toPokemon:[self pokemon]
                                    completion:^(BOOL result, NSError *error) {
                                        @strongify(self);
                                        if ([[self delegate] respondsToSelector:@selector(controllerDidSelectMove:error:)]) {
                                            [[self delegate] performSelector:@selector(controllerDidSelectMove:error:)
                                                                  withObject:[move copy]
                                                                  withObject:error];
                                        }
                                        NSArray *controllers = [[self navigationController] viewControllers];
                                        [[self navigationController] popToViewController:[controllers objectAtIndex:1]
                                                                                animated:YES];
                                    }];
}

@end
