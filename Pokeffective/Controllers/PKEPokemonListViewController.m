//
//  PKESearchViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 05/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPokemonListViewController.h"
#import "PKEPokemonManager.h"
#import "PKEPokemonCell.h"
#import "PKEPokemon.h"
#import "PKEPokemonSearchViewController.h"

@interface PKEPokemonListViewController () <PKEPokemonTableViewControllerDataSource>

- (void)searchButtonTapped:(id)sender;
- (void)filterButtonTapped:(id)sender;

@end

@implementation PKEPokemonListViewController

static void * PKEListViewControllerContext = &PKEListViewControllerContext;

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
                                        forKeyPath:NSStringFromSelector(@selector(filteringPokedexType))
                                           options:NSKeyValueObservingOptionNew
                                           context:PKEListViewControllerContext];
    [[PKEPokemonManager sharedManager] addObserver:self
                                        forKeyPath:NSStringFromSelector(@selector(filteringPokemonType))
                                           options:NSKeyValueObservingOptionNew
                                           context:PKEListViewControllerContext];
    [SVProgressHUD show];
    [[PKEPokemonManager sharedManager] getPokemonsWithCompletion:^(NSArray *array, NSError *error) {
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
    if (context == PKEListViewControllerContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(filteringPokedexType))] ||
            [keyPath isEqualToString:NSStringFromSelector(@selector(filteringPokemonType))]) {
            [[PKEPokemonManager sharedManager] getPokemonsWithCompletion:^(NSArray *array, NSError *error) {
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
                                           forKeyPath:NSStringFromSelector(@selector(filteringPokedexType))];
    [[PKEPokemonManager sharedManager] removeObserver:self
                                           forKeyPath:NSStringFromSelector(@selector(filteringPokemonType))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        PKEPokemonSearchViewController *searchViewController = [segue destinationViewController];
        searchViewController.delegate = self.delegate;
        [searchViewController setDataSource:[self dataSource]];
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

#pragma mark - PKETableViewControllerDataSource

- (PKEPokemon *)getPokemonForIndexPath:(NSIndexPath *)indexPath
                           inTableView:(UITableView *)tableView
{
    return [[self dataSource] objectAtIndex:[indexPath row]];
}

@end
