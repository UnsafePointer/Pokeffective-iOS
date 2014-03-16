//
//  PKEMoveTableViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEMoveTableViewController.h"
#import "PKEMoveCell.h"
#import "PKEPokemonManager.h"
#import "PKEMove.h"

@interface PKEMoveTableViewController () <PKEMoveTableViewControllerDataSource>

- (void)configureTableViewCell:(PKEMoveCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
                   inTableView:(UITableView *)tableView;

@end

@implementation PKEMoveTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"PKEMoveCell"
                                bundle:[NSBundle mainBundle]];
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"MoveCell"];
    [[[self searchDisplayController] searchResultsTableView] registerNib:nib
                                                  forCellReuseIdentifier:@"MoveCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoveCell";
    PKEMoveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                        forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath
                     inTableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKEMove *move = [self getMoveForIndexPath:indexPath
                                  inTableView:tableView];
    @weakify(self);
    [[PKEPokemonManager sharedManager] addMove:move
                                     toPokemon:[self pokemon]
                                    completion:^(BOOL result, NSError *error) {
                                        @strongify(self);
                                        if ([[self delegate] respondsToSelector:@selector(tableViewControllerDidSelectMove:error:)]) {
                                            [[self delegate] performSelector:@selector(tableViewControllerDidSelectMove:error:)
                                                                  withObject:[move copy]
                                                                  withObject:error];
                                        }
                                        NSArray *controllers = [[self navigationController] viewControllers];
                                        [[self navigationController] popToViewController:[controllers objectAtIndex:1]
                                                                                animated:YES];
                                    }];
}

#pragma mark - Private Methods

- (void)configureTableViewCell:(PKEMoveCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
                   inTableView:(UITableView *)tableView
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEMove *move = [self getMoveForIndexPath:indexPath
                                  inTableView:tableView];
    [[tableViewCell lblName] setText:[move name]];
    [[tableViewCell lblCategory] setText:[[PKEPokemonManager sharedManager] nameForCategory:[move category]]];
    [[tableViewCell lblDetails] setText:[NSString stringWithFormat:@"%d / %d", [move power], [move accuracy]]];
    [tableViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[move type]]];
}

@end
