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
#import "PKEPokemon.h"
#import "PKEMoveListViewController.h"
#import "PKEMoveCollectionViewCell.h"
#import "NSError+PKEPokemonError.h"
#import "PKEMoveControllerDelegate.h"
#import "TLAlertView.h"

@interface PKEMovesetViewController () <PKEMoveControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (void)updateMovesetWithMove:(PKEMove *)move;
- (void)onLongPressMoveCell:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation PKEMovesetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[[self pokemon] name]];
    if (![[self pokemon] moves] || [[[self pokemon] moves] count] == 0) {
        [self setDataSource:[NSArray array]];
        [[self lblNoContent] setAlpha:1.0f];
    }
    else {
        [self setDataSource:[[[self pokemon] moves] allObjects]];
    }
    [[self collectionView] reloadData];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(onLongPressMoveCell:)];
    [[self collectionView] addGestureRecognizer:recognizer];
    [[self lblNoContent] setText:EMPTY_MOVESET];
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

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Public Methods

- (IBAction)onTapAddButton:(id)sender
{
    if ([[self dataSource] count] < MAX_POKEMON_MOVES) {
        [self performSegueWithIdentifier:@"MovesSegue"
                                  sender:self];
    }
    else {
        TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You can't save more than four moves for a pokemon in your party. Remove one first in order to add another."
                                                        buttonTitle:@"OK"];
        [alertView show];
    }
}

#pragma mark - Private Methods

- (void)onLongPressMoveCell:(UIGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:[self collectionView]]];
        if (indexPath != nil) {
            [self setSelectedIndexPath:indexPath];
            PKEMove *move = [[self dataSource] objectAtIndex:[indexPath row]];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Remove %@ from %@?", [move name], [[self pokemon] name]]
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:@"Remove"
                                                            otherButtonTitles:nil];
            [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
        }
    }
}

- (void)updateMovesetWithMove:(PKEMove *)move
{
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

#pragma mark - PKEMoveControllerDelegate

- (void)controllerDidSelectMove:(PKEMove *)move
                          error:(NSError *)error
{
    if (!error) {
        @weakify(self)
        if ([[self lblNoContent] alpha]) {
            [UIView animateWithDuration:0.5f
                             animations:^{
                                 @strongify(self)
                                 [[self lblNoContent] setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 @strongify(self)
                                 if (finished) {
                                     [self updateMovesetWithMove:move];
                                 }
                             }];
        }
        else {
            [self updateMovesetWithMove:move];
        }
    }
    else {
        if ([[error domain] isEqualToString:PKEErrorMoveDomain]) {
            PKEErrorCodeMove code = [error code];
            switch (code) {
                case kPKEErrorCodeSavingSameMove:
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:@"You can't save the same move twice for a pokemon in your party."
                                                           type:TSMessageNotificationTypeError
                                                       duration:3.0f
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
        PKEMove *move = [self getMoveForIndexPath:[self selectedIndexPath]
                                 inCollectionView:[self collectionView]];
        [[PKEPokemonManager sharedManager] removeMove:move
                                            toPokemon:[self pokemon]
                                           completion:^(BOOL result, NSError *error) {
                                               @weakify(self)
                                               if (!error) {
                                                   [[self collectionView] performBatchUpdates:^{
                                                       @strongify(self);
                                                       if (!error) {
                                                           NSMutableArray *mutableDataSource = [[self dataSource] mutableCopy];
                                                           [mutableDataSource removeObject:move];
                                                           [self setDataSource:[mutableDataSource copy]];
                                                           [[self pokemon] setMoves:[NSSet setWithArray:[self dataSource]]];
                                                           [[self collectionView] deleteItemsAtIndexPaths:@[[self selectedIndexPath]]];
                                                       }
                                                   } completion:^(BOOL finished) {
                                                       if (finished) {
                                                           if ([[self dataSource] count] <= 0) {
                                                               if (![[self lblNoContent] alpha]) {
                                                                   [UIView animateWithDuration:0.5f
                                                                                    animations:^{
                                                                                        @strongify(self)
                                                                                        [[self lblNoContent] setAlpha:1.0f];
                                                                                    }];
                                                               }
                                                           }
                                                       }
                                                   }];
                                               }
                                           }];
    }
}

@end
