//
//  PKEPartyViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPartyViewController.h"
#import "PKEPokemonManager.h"
#import "PKEMemberCell.h"
#import "PKEPokemon.h"
#import "PKEMovesetViewController.h"
#import "PKETableViewController.h"
#import "NSError+PokemonError.h"

@interface PKEPartyViewController () <PKETableViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (void)addButtonTapped:(id)sender;
- (void)chartButtonTapped:(id)sender;

@end

@implementation PKEPartyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(addButtonTapped:)];
    UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Chart"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(chartButtonTapped:)];
    [self.navigationItem setRightBarButtonItems:@[searchBarButtonItem, filterBarButtonItem]];
    [[PKEPokemonManager sharedManager] getPartyWithCompletion:^(NSArray *array, NSError *error) {
        @weakify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (!error) {
                [self setDataSource:array];
                [[self collectionView] reloadData];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MovesetSegue"]) {
        PKEMovesetViewController *controller = [segue destinationViewController];
        NSArray *selectedIndexPaths = [[self collectionView] indexPathsForSelectedItems];
        NSIndexPath *selectedIndesPath = [selectedIndexPaths objectAtIndex:0];
        PKEPokemon *selectedPKMN = [[self dataSource] objectAtIndex:[selectedIndesPath row]];
        controller.pokemon = selectedPKMN;
    }
    if ([[segue identifier] isEqualToString:@"AddSegue"]) {
        PKETableViewController *controller = [segue destinationViewController];
        [controller setDelegate:self];
    }
}

#pragma mark - Private Methods

- (void)addButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"AddSegue"
                              sender:self];
}

- (void)chartButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"EffectiveSegue"
                              sender:self];
}

- (void)configureTableViewCell:(PKEMemberCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEPokemon *pokemon = [[self dataSource] objectAtIndex:[indexPath row]];
    [[tableViewCell lblName] setText:[pokemon name]];
    [[tableViewCell imgPicture] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d.png", [pokemon identifier]]]];
    if ([pokemon secondType] == PKEPokemonTypeNone) {
        [tableViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]];
    }
    else {
        [tableViewCell addBackgroundLayersWithFirstColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]
                                             secondColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon secondType]]];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MemberCell";
    PKEMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                    forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

#pragma mark - PKETableViewControllerDelegate

- (void)tableViewControllerDidSelectPokemon:(PKEPokemon *)pokemon
                                      error:(NSError *)error
{
    if (!error) {
        @weakify(self)
        [[self collectionView] performBatchUpdates:^{
            @strongify(self)
            NSMutableArray *mutableDataSource = [[self dataSource] mutableCopy];
            [mutableDataSource addObject:pokemon];
            [self setDataSource:[mutableDataSource copy]];
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
        if ([[error domain] isEqualToString:PKEErrorDomain]) {
            PKEErrorCode code = [error code];
            switch (code) {
                case kPKEErrorCodeSavingMoreThanSixPokemons:
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:@"You can't save more than six pokemons in your party."
                                                           type:TSMessageNotificationTypeError
                                                       duration:2.0f
                                           canBeDismissedByUser:YES];
                    break;
                case kPKEErrorCodeSavingSamePokemon:
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:@"You can't save the same pokemon twice in your party."
                                                           type:TSMessageNotificationTypeError
                                                       duration:2.0f
                                           canBeDismissedByUser:YES];
                    break;
            }
        }
    }
}

#pragma mark - Public Methods

- (IBAction)onLongPressMemberCell:(id)sender
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        PKEPokemon *pokemon = [[self dataSource] objectAtIndex:[[self selectedIndexPath] row]];
        [[PKEPokemonManager sharedManager] removePokemonFromParty:pokemon
                                                       completion:^(BOOL result, NSError *error) {
                                                           @weakify(self)
                                                           [[self collectionView] performBatchUpdates:^{
                                                               @strongify(self);
                                                               if (!error) {
                                                                   NSMutableArray *mutableDataSource = [[self dataSource] mutableCopy];
                                                                   [mutableDataSource removeObject:pokemon];
                                                                   [self setDataSource:[mutableDataSource copy]];
                                                                   [[self collectionView] deleteItemsAtIndexPaths:@[[self selectedIndexPath]]];
                                                               }
                                                           } completion:nil];
                                                       }];
    }
}

@end
