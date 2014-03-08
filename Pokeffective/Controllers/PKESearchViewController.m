//
//  PKESearchViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 05/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKESearchViewController.h"
#import "PKEDataBaseManager.h"
#import "PKEPokemonCell.h"
#import "PKEPokemon.h"

@interface PKESearchViewController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *filteredDataSource;

- (void)configureTableViewCell:(PKEPokemonCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
                   inTableView:(UITableView *)tableView;

@end

@implementation PKESearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDataSource:[[PKEDataBaseManager sharedManager] getPokemons]];
    [self setFilteredDataSource:[NSMutableArray array]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Methods

- (IBAction)searchButtonTapped:(id)sender
{
    
}

#pragma mark - Private Methods

-(void)filterContentForSearchText:(NSString*)searchText
{
    [[self filteredDataSource] removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    [[self filteredDataSource] addObjectsFromArray:[[self dataSource] filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [[self filteredDataSource] count];
    }
    else {
        return [[self dataSource] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PokemonCell";
    PKEPokemonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier
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
    PKEPokemon *pokemon = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        pokemon = [[self filteredDataSource] objectAtIndex:[indexPath row]];
    }
    else {
        pokemon = [[self dataSource] objectAtIndex:[indexPath row]];
    }
    [[tableViewCell lblName] setText:[pokemon name]];
    [[tableViewCell lblNumber] setText:[pokemon number]];
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

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
        shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{

}

@end
