//
//  PKEEffectiveViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEEffectiveViewController.h"
#import "PKEEffectiveCell.h"
#import "PKEDataBaseManager.h"

@interface PKEEffectiveViewController ()

@property (nonatomic, strong) NSDictionary *dataSource;

@end

@implementation PKEEffectiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDataSource:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Types"
                                                                                                   ofType:@"plist"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self dataSource] allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EffectiveCell";
    PKEEffectiveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                             forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

#pragma mark - Private Methods

- (void)configureTableViewCell:(PKEEffectiveCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    NSArray *keys = [[self dataSource] allKeys];
    keys = [keys sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSCaseInsensitiveSearch];
    }];
    NSString *key = [keys objectAtIndex:[indexPath row]];
    [[tableViewCell lblType] setText:key];
    NSString *randomEffective = [[PKEDataBaseManager sharedManager] getRandomEffective];
    [[tableViewCell lblEffective] setText:randomEffective];
    [tableViewCell addBackgroundLayersWithFirstColor:[[PKEDataBaseManager sharedManager] getColorForType:key]
                                         secondColor:[[PKEDataBaseManager sharedManager] getColorForEffective:randomEffective]
                                    middleWhitespace:YES];
}

@end
