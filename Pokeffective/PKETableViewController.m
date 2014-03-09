//
//  PKETableViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKETableViewController.h"
#import "PKEDataBaseManager.h"
#import "PKEPokemonCell.h"
#import "PKEPokemon.h"

@interface PKETableViewController () <PKETableViewControllerDataSource>

- (void)configureTableViewCell:(PKEPokemonCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
                   inTableView:(UITableView *)tableView;

@end

@implementation PKETableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDataSource:[[PKEDataBaseManager sharedManager] getPokemons]];
    UINib *nib = [UINib nibWithNibName:@"PKEPokemonCell"
                                bundle:[NSBundle mainBundle]];
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"PokemonCell"];
    [[[self searchDisplayController] searchResultsTableView] registerNib:nib
           forCellReuseIdentifier:@"PokemonCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PokemonCell";
    PKEPokemonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                           forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath
                     inTableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f;
}

#pragma mark - Private Methods

- (void)configureTableViewCell:(PKEPokemonCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
                   inTableView:(UITableView *)tableView
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEPokemon *pokemon = [self getPokemonForIndexPath:indexPath
                                           inTableView:tableView];
    [[tableViewCell lblName] setText:[pokemon name]];
    [[tableViewCell lblNumber] setText:[NSString stringWithFormat:@"%03d",[[pokemon number] intValue]]];
    [[tableViewCell imgPicture] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [pokemon number]]]];
    if ([[pokemon types] count] == 1) {
        [[tableViewCell lblTypes] setText:[[pokemon types] firstObject]];
        [tableViewCell addBackgroundLayersWithColor:[[PKEDataBaseManager sharedManager] getColorForType:[[pokemon types] objectAtIndex:0]]];
    }
    else {
        [[tableViewCell lblTypes] setText:[NSString stringWithFormat:@"%@ / %@", [[pokemon types] objectAtIndex:0],  [[pokemon types] objectAtIndex:1]]];
        [tableViewCell addBackgroundLayersWithFirstColor:[[PKEDataBaseManager sharedManager] getColorForType:[[pokemon types] objectAtIndex:0]]
                                             secondColor:[[PKEDataBaseManager sharedManager] getColorForType:[[pokemon types] objectAtIndex:1]]];
    }
    
}

@end
