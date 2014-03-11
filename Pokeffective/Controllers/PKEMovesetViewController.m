//
//  PKEMovesetViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEMovesetViewController.h"
#import "PKEDataBaseManager.h"
#import "PKEMoveCell.h"
#import "PKEMove.h"
#import "PKELabel.h"
#import "PKEPokemon.h"
#import <HexColors/HexColor.h>

@interface PKEMovesetViewController ()

@property (nonatomic, strong) NSArray *dataSource;

- (void)configureTableViewCell:(PKEMoveCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PKEMovesetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDataSource:[[PKEDataBaseManager sharedManager] getMoveset]];
    [self setTitle:[[self pokemon] name]];
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
    static NSString *CellIdentifier = @"MoveCell";
    PKEMoveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                           forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PKELabel *lblHeader = [[PKELabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 22.0f)
                                            andEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 15.0f)];
    [lblHeader setText:@"Power / Accuracy"];
    [lblHeader setTextAlignment:NSTextAlignmentRight];
    [lblHeader setTextColor:[UIColor colorWithHexString:@"#1D62F0"]];
    [lblHeader setFont:[UIFont systemFontOfSize:13.0f]];
    return lblHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

#pragma mark - Private Methods

- (void)configureTableViewCell:(PKEMoveCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEMove *move = [[self dataSource] objectAtIndex:[indexPath row]];
    [[tableViewCell lblName] setText:[move name]];
    [[tableViewCell lblCategory] setText:[move category]];
    [[tableViewCell lblDetails] setText:[NSString stringWithFormat:@"%d / %d%%", [[move power] integerValue], [[move accuracy] intValue]]];
    [tableViewCell addBackgroundLayersWithColor:[[PKEDataBaseManager sharedManager] getColorForType:[move type]]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

@end
