//
//  PKETypeViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKETypeViewController.h"
#import "PKETypeCell.h"
#import "PKEDataBaseManager.h"

@interface PKETypeViewController ()

@property (nonatomic, strong) NSDictionary *dataSource;

@end

@implementation PKETypeViewController

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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self dataSource] allKeys] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TypeCell";
    PKETypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                  forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

#pragma mark - Private Methods

- (void)configureTableViewCell:(PKETypeCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    NSArray *keys = [[self dataSource] allKeys];
    keys = [keys sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSCaseInsensitiveSearch];
    }];
    NSString *key = [keys objectAtIndex:[indexPath row]];
    [[tableViewCell lblName] setText:key];
    [tableViewCell addBackgroundLayersWithColor:[[PKEDataBaseManager sharedManager] getColorForType:key]];
}

@end
