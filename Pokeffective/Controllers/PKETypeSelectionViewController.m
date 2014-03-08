//
//  PKETypeSelectionViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKETypeSelectionViewController.h"
#import "PKETableViewCell.h"
#import "PKEDataBaseManager.h"

@interface PKETypeSelectionViewController ()

@property (nonatomic, strong) NSDictionary *dataSource;

- (void)configureTableViewCell:(PKETableViewCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PKETypeSelectionViewController

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
    static NSString *CellIdentifier = @"TypeCell";
    PKETableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                             forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

#pragma mark - Private Methods

- (void)configureTableViewCell:(PKETableViewCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    NSArray *keys = [[self dataSource] allKeys];
    keys = [keys sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSCaseInsensitiveSearch];
    }];
    NSString *key = [keys objectAtIndex:[indexPath row]];
    [tableViewCell.textLabel setText:key];
    [tableViewCell addBackgroundLayersWithColor:[[PKEDataBaseManager sharedManager] getColorForType:key]];
}

@end
