//
//  PKEFilterViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPokemonFilterViewController.h"
#import "PKEPokemonManager.h"

@interface PKEPokemonFilterViewController ()

@property (nonatomic, strong) NSIndexPath *selectionIndexPath;

@end

@implementation PKEPokemonFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSelectionIndexPath:[[PKEPokemonManager sharedManager] indexPathForPokedexType:[[PKEPokemonManager sharedManager] filteringPokedexType]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self lblTypeFilter] setText:[[PKEPokemonManager sharedManager] nameForType:[[PKEPokemonManager sharedManager] filteringPokemonType]]];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([indexPath section] == [[self selectionIndexPath] section] &&
        [indexPath row] == [[self selectionIndexPath] row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PKEPokedexType pokedexType = [[PKEPokemonManager sharedManager] pokedexTypeForIndexPath:indexPath];
        [[PKEPokemonManager sharedManager] setFilteringPokedexType:pokedexType];
        UITableViewCell *currentSelectionCell = [[self tableView] cellForRowAtIndexPath:[self selectionIndexPath]];
        currentSelectionCell.accessoryType = UITableViewCellAccessoryNone;
        UITableViewCell *selectionCell = [[self tableView] cellForRowAtIndexPath:indexPath];
        selectionCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
        [self setSelectionIndexPath:indexPath];
    }
}

@end
