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

- (void)configureTableViewCell:(PKEPokemonCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PKESearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self tableView] setContentOffset:CGPointMake(0, 44)];
    [self setDataSource:[[PKEDataBaseManager sharedManager] getPokemons]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PokemonCell";
    PKEPokemonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                           forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

#pragma mark - Private Methods

- (void)configureTableViewCell:(PKEPokemonCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    PKEPokemon *pokemon = [[self dataSource] objectAtIndex:[indexPath row]];
    [[tableViewCell lblName] setText:[pokemon name]];
    [[tableViewCell lblNumber] setText:[pokemon number]];
    [[tableViewCell imgPicture] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [pokemon number]]]];
    if ([[pokemon types] count] == 1) {
        [[tableViewCell lblTypes] setText:[[pokemon types] firstObject]];
    }
    else {
        [[tableViewCell lblTypes] setText:[NSString stringWithFormat:@"%@ / %@", [[pokemon types] objectAtIndex:0],  [[pokemon types] objectAtIndex:1]]];
    }
    [tableViewCell addCustomLayerToContentView];
}

@end
