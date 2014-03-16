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

@interface PKEMoveListViewController () <PKEMoveTableViewControllerDataSource>

- (void)searchButtonTapped:(id)sender;
- (void)filterButtonTapped:(id)sender;

@end

static void * PKEMoveListViewControllerContext = &PKEMoveListViewControllerContext;

@implementation PKEMoveListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
                                                           [[self tableView] reloadData];
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
                                                                   [[self tableView] reloadData];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

#pragma mark - PKEMoveTableViewControllerDataSource

- (PKEMove *)getMoveForIndexPath:(NSIndexPath *)indexPath
                        inTableView:(UITableView *)tableView
{
    return [[self dataSource] objectAtIndex:[indexPath row]];
}

@end
