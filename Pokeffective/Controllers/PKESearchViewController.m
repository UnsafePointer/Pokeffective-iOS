//
//  PKEViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKESearchViewController.h"
#import <HexColors/HexColor.h>

@interface PKESearchViewController () <PKETableViewControllerDataSource>

@property (nonatomic, strong) NSMutableArray *filteredDataSource;

-(void)filterContentForSearchText:(NSString*)searchText;

@end

@implementation PKESearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFilteredDataSource:[NSMutableArray array]];
    [[self searchDisplayController] setDisplaysSearchBarInNavigationBar:YES];
    UITextField *searchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
    searchField.tintColor = [UIColor colorWithHexString:@"#1D62F0"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[[self searchDisplayController] searchBar] becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([[[self searchDisplayController] searchBar] isFirstResponder]) {
        [[[self searchDisplayController] searchBar] resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

-(void)filterContentForSearchText:(NSString*)searchText
{
    [[self filteredDataSource] removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    [[self filteredDataSource] addObjectsFromArray:[[self dataSource] filteredArrayUsingPredicate:predicate]];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [[self filteredDataSource] count];
    }
    else {
        return 0;
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PKETableViewControllerDataSource

- (PKEPokemon *)getPokemonForIndexPath:(NSIndexPath *)indexPath
                           inTableView:(UITableView *)tableView
{
    PKEPokemon *pokemon = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        pokemon = [[self filteredDataSource] objectAtIndex:[indexPath row]];
    }
    return pokemon;
}

@end
