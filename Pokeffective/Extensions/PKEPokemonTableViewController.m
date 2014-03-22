//
//  PKETableViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPokemonTableViewController.h"
#import "PKEPokemonManager.h"
#import "PKEPokemonTableViewCell.h"
#import "PKEPokemon.h"

@interface PKEPokemonTableViewController () <PKEPokemonTableViewControllerDataSource>

- (void)configureTableViewCell:(PKEPokemonTableViewCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
                   inTableView:(UITableView *)tableView;

@end

@implementation PKEPokemonTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"PKEPokemonTableViewCell"
                                bundle:[NSBundle mainBundle]];
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"PokemonTableViewCell"];
    [[[self searchDisplayController] searchResultsTableView] registerNib:nib
           forCellReuseIdentifier:@"PokemonTableViewCell"];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PokemonTableViewCell";
    PKEPokemonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKEPokemon *pokemon = [self getPokemonForIndexPath:indexPath
                                           inTableView:tableView];
    @weakify(self);
    [[PKEPokemonManager sharedManager] addPokemonToParty:pokemon
                                              completion:^(BOOL result, NSError *error) {
                                                  @strongify(self);
                                                  if ([[self delegate] respondsToSelector:@selector(tableViewControllerDidSelectPokemon:error:)]) {
                                                      [[self delegate] performSelector:@selector(tableViewControllerDidSelectPokemon:error:)
                                                                            withObject:[pokemon copy]
                                                                            withObject:error];
                                                  }
                                                  [[self navigationController] popToRootViewControllerAnimated:YES];
                                              }];
}

#pragma mark - Private Methods

- (void)configureTableViewCell:(PKEPokemonTableViewCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
                   inTableView:(UITableView *)tableView
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEPokemon *pokemon = [self getPokemonForIndexPath:indexPath
                                           inTableView:tableView];
    [[tableViewCell lblName] setText:[pokemon name]];
    [[tableViewCell lblNumber] setText:[NSString stringWithFormat:@"%03d", [pokemon pokedexNumber]]];
    [[tableViewCell imgPicture] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d.png", [pokemon identifier]]]];
    if ([pokemon secondType] == PKEPokemonTypeNone) {
        [[tableViewCell lblTypes] setText:[[PKEPokemonManager sharedManager] nameForType:[pokemon firstType]]];
        [tableViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]];
    }
    else {
        [[tableViewCell lblTypes] setText:[NSString stringWithFormat:@"%@ / %@", [[PKEPokemonManager sharedManager] nameForType:[pokemon firstType]],  [[PKEPokemonManager sharedManager] nameForType:[pokemon secondType]]]];
        [tableViewCell addBackgroundLayersWithFirstColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]
                                             secondColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon secondType]] middleWhitespace:NO];
    }
    
}

@end
