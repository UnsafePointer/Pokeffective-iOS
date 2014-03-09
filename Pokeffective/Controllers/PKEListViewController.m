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

@end

@implementation PKEListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
