//
//  PKEMovesetViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEMovesetViewController.h"
#import "PKEPokemonManager.h"
#import "PKEMoveTableViewCell.h"
#import "PKEMove.h"
#import "PKELabel.h"
#import "PKEPokemon.h"
#import "PKEMoveListViewController.h"
#import "PKEMoveCollectionViewCell.h"
#import "NSError+PokemonError.h"

@interface PKEMovesetViewController () <PKEMoveTableViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (void)configureCollectionViewCell:(PKEMoveCollectionViewCell *)tableViewCell
                       forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PKEMovesetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[[self pokemon] name]];
    UINib *nib = [UINib nibWithNibName:@"PKEMoveCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [[self collectionView] registerNib:nib
            forCellWithReuseIdentifier:@"MoveCollectionViewCell"];
    if (![[self pokemon] moves]) {
        [self setDataSource:[NSArray array]];
    }
    else {
        [self setDataSource:[[[self pokemon] moves] allObjects]];
    }
    [[self collectionView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MovesSegue"]) {
        PKEMoveListViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        [controller setPokemon:[self pokemon]];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoveCollectionViewCell";
    PKEMoveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
    [self configureCollectionViewCell:cell
                         forIndexPath:indexPath];
    return cell;
}

#pragma mark - Public Methods

- (IBAction)onLongPressMoveCell:(id)sender
{
    UILongPressGestureRecognizer *gestureRecognizer = (UILongPressGestureRecognizer *)sender;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:[self collectionView]]];
        if (indexPath != nil) {
            [self setSelectedIndexPath:indexPath];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Remove from party"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:@"Remove"
                                                            otherButtonTitles:nil];
            [actionSheet showInView:[self view]];
        }
    }
}

#pragma mark - Private Methods

- (PKEMove *)getMoveForIndexPath:(NSIndexPath *)indexPath
{
    return [[self dataSource] objectAtIndex:[indexPath row]];
}

- (void)configureCollectionViewCell:(PKEMoveCollectionViewCell *)tableViewCell
                       forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEMove *move = [self getMoveForIndexPath:indexPath];
    [[tableViewCell lblName] setText:[move name]];
    [[tableViewCell lblCategory] setText:[[PKEPokemonManager sharedManager] nameForCategory:[move category]]];
    [[tableViewCell lblDetails] setText:[NSString stringWithFormat:@"%d / %d", [move power], [move accuracy]]];
    [tableViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[move type]]];
}

#pragma mark - PKEMoveTableViewControllerDelegate

- (void)tableViewControllerDidSelectMove:(PKEMove *)move
                                   error:(NSError *)error
{
    if (!error) {
        @weakify(self)
        [[self collectionView] performBatchUpdates:^{
            @strongify(self)
            NSMutableArray *mutableDataSource = [[self dataSource] mutableCopy];
            [mutableDataSource addObject:move];
            [self setDataSource:[mutableDataSource copy]];
            [[self pokemon] setMoves:[NSSet setWithArray:[self dataSource]]];
            [[self collectionView] insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[mutableDataSource count] - 1
                                                                                 inSection:0]]];
        }
                                        completion:^(BOOL finished) {
                                            @strongify(self)
                                            if (finished) {
                                                [[self collectionView] scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[[self dataSource] count] - 1
                                                                                                                   inSection:0]
                                                                              atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                                                                      animated:YES];
                                            }
                                        }];
    }
    else {
        if ([[error domain] isEqualToString:PKEErrorMoveDomain]) {
            PKEErrorCodeMove code = [error code];
            switch (code) {
                case kPKEErrorCodeSavingMoreThanFourMoves:
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:@"You can't save more than four moves for a pokemon in your party."
                                                           type:TSMessageNotificationTypeError
                                                       duration:2.0f
                                           canBeDismissedByUser:YES];
                    break;
                case kPKEErrorCodeSavingSameMove:
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:@"You can't save the same move twice for a pokemon in your party."
                                                           type:TSMessageNotificationTypeError
                                                       duration:2.0f
                                           canBeDismissedByUser:YES];
                    break;
            }
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        PKEMove *move = [[self dataSource] objectAtIndex:[[self selectedIndexPath] row]];
        [[PKEPokemonManager sharedManager] removeMove:move
                                            toPokemon:[self pokemon]
                                           completion:^(BOOL result, NSError *error) {
                                               @weakify(self)
                                               [[self collectionView] performBatchUpdates:^{
                                                   @strongify(self);
                                                   if (!error) {
                                                       NSMutableArray *mutableDataSource = [[self dataSource] mutableCopy];
                                                       [mutableDataSource removeObject:move];
                                                       [self setDataSource:[mutableDataSource copy]];
                                                       [[self pokemon] setMoves:[NSSet setWithArray:[self dataSource]]];
                                                       [[self collectionView] deleteItemsAtIndexPaths:@[[self selectedIndexPath]]];
                                                   }
                                               } completion:nil];
                                           }];
    }
}

@end
