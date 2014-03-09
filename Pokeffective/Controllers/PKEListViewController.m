//
//  PKESearchViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 05/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEListViewController.h"
#import "PKEDataBaseManager.h"
#import "PKEPokemonCell.h"
#import "PKEPokemon.h"

@interface PKEListViewController () <PKETableViewControllerDataSource>

- (void)searchButtonTapped:(id)sender;
- (void)filterButtonTapped:(id)sender;

@end

@implementation PKEListViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
