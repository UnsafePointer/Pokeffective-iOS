//
//  PKEFilterViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEFilterViewController.h"
#import "PKEPokemonManager.h"

@interface PKEFilterViewController ()

@property (nonatomic, strong) NSArray *selectionIndexPaths;

@end

@implementation PKEFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch ([self filterType]) {
        case kPKEFilerTypePokemon: {
            [self setSelectionIndexPaths:@[[[PKEPokemonManager sharedManager] indexPathForPokedexType:[[PKEPokemonManager sharedManager] filteringPokedexType]]]];
            break;
        }
        case kPKEFilerTypeMoves:
            [self setSelectionIndexPaths:@[
                                           [[PKEPokemonManager sharedManager] indexPathForMoveMethod:[[PKEPokemonManager sharedManager] filteringMoveMethod]],
                                           [[PKEPokemonManager sharedManager] indexPathForMoveCategory:[[PKEPokemonManager sharedManager] filteringMoveCategory]]
                                           ]];
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    switch ([self filterType]) {
        case kPKEFilerTypePokemon:
            [[self lblTypeFilter] setText:[[PKEPokemonManager sharedManager] nameForType:[[PKEPokemonManager sharedManager] filteringPokemonType]]];
            break;
        case kPKEFilerTypeMoves:
            [[self lblTypeFilter] setText:[[PKEPokemonManager sharedManager] nameForType:[[PKEPokemonManager sharedManager] filteringMoveType]]];
            break;
    }
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    for (NSIndexPath *selectionIndexPath in [self selectionIndexPaths]) {
        if ([indexPath section] == [selectionIndexPath section] &&
            [indexPath row] == [selectionIndexPath row]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section + 1) != [self numberOfSectionsInTableView:tableView]) {
        switch ([self filterType]) {
            case kPKEFilerTypePokemon: {
                PKEPokedexType pokedexType = [[PKEPokemonManager sharedManager] pokedexTypeForIndexPath:indexPath];
                [[PKEPokemonManager sharedManager] setFilteringPokedexType:pokedexType];
                break;
            }
            case kPKEFilerTypeMoves: {
                if ([indexPath section] == 0) {
                    PKEMoveMethod moveMethod = [[PKEPokemonManager sharedManager] moveMethodForIndexPath:indexPath];
                    [[PKEPokemonManager sharedManager] setFilteringMoveMethod:moveMethod];
                }
                else {
                    PKEMoveCategory moveCategory = [[PKEPokemonManager sharedManager] moveCategoryForIndexPath:indexPath];
                    [[PKEPokemonManager sharedManager] setFilteringMoveCategory:moveCategory];
                }
                break;
            }
        }
        UITableViewCell *currentSelectionCell = [[self tableView] cellForRowAtIndexPath:[[self selectionIndexPaths] objectAtIndex:[indexPath section]]];
        currentSelectionCell.accessoryType = UITableViewCellAccessoryNone;
        UITableViewCell *selectionCell = [[self tableView] cellForRowAtIndexPath:indexPath];
        selectionCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
        NSMutableArray *selections = [[self selectionIndexPaths] mutableCopy];
        [selections replaceObjectAtIndex:[indexPath section] withObject:indexPath];
        [self setSelectionIndexPaths:[selections copy]];
    }
}

@end
