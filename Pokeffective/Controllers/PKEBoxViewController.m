//
//  PKEPartyViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEBoxViewController.h"
#import "PKEPokemonManager.h"
#import "PKEMemberCollectionViewCell.h"
#import "PKEPokemon.h"
#import "PKEMovesetViewController.h"
#import "PKEPokemonListViewController.h"
#import "NSError+PKEPokemonError.h"
#import "PKEBoxCollectionViewFlowLayout.h"
#import "TLAlertView.h"
#import "PKEPartySelectionViewController.h"

@interface PKEBoxViewController () <PKEPokemonTableViewControllerDelegate, UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, PKEMovesetViewControllerDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, weak) UILabel *lblNoContent;
@property (nonatomic, weak) UICollectionView *collectionView;

- (void)addButtonTapped:(id)sender;
- (void)chartButtonTapped:(id)sender;
- (void)configureTableViewCell:(PKEMemberCollectionViewCell *)tableViewCell
                  forIndexPath:(NSIndexPath *)indexPath;
- (void)configureNoContentLabel;
- (void)configureCollectionView;
- (void)onLongPressMemberCell:(UIGestureRecognizer *)gestureRecognizer;
- (void)updatePartyWithPokemon:(PKEPokemon *)pokemon;
- (void)calculateProgress;
- (void)updateProgress;

@end

@implementation PKEBoxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureCollectionView];
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(addButtonTapped:)];
    UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Chart"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(chartButtonTapped:)];
    [self.navigationItem setRightBarButtonItems:@[searchBarButtonItem, filterBarButtonItem]];
    UINib *nib = [UINib nibWithNibName:@"PKEMemberCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [[self collectionView] registerNib:nib
            forCellWithReuseIdentifier:@"MemberCollectionViewCell"];
    [self configureNoContentLabel];
    [[PKEPokemonManager sharedManager] getBoxWithCompletion:^(NSArray *array, NSError *error) {
        @weakify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                @strongify(self);
                [self setDataSource:array];
                if ([[self dataSource] count] == 0) {
                    [[self lblNoContent] setAlpha:1.0f];
                }
                else {
                    [[self collectionView] reloadData];
                }
                [self updateProgress];
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
        controller.delegate = self;
        [controller setPokemon:selectedPKMN];
    }
    if ([[segue identifier] isEqualToString:@"AddSegue"]) {
        PKEPokemonListViewController *controller = [segue destinationViewController];
        [controller setDelegate:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self collectionView] deselectItemAtIndexPath:[[[self collectionView] indexPathsForSelectedItems] firstObject]
                                          animated:YES];
}

#pragma mark - Public Methods

- (IBAction)onTapInfoButton:(id)sender
{
    UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main"
                                                                              bundle:nil] instantiateViewControllerWithIdentifier:@"PKEAboutViewController"];
    [self presentViewControllerWithFadebackAnimation:navigationController
                                          completion:nil];
}

#pragma mark - Private Methods

- (void)calculateProgress
{
    CGFloat progress = 0.0f;
    NSUInteger pokemonCount = 0;
    NSMutableArray *movesCount = [NSMutableArray arrayWithArray:@[@0, @0, @0]];
    NSArray *movesCountSorted;
    for (PKEPokemon *pokemon in [self dataSource]) {
        if (pokemonCount < 3) {
            pokemonCount++;
        }
        [movesCount addObject:[NSNumber numberWithInt:[[pokemon moves] count]]];
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                                     ascending:NO];
    movesCountSorted = [movesCount sortedArrayUsingDescriptors:@[sortDescriptor]];
    for (int i = 0; i < 3; i++) {
        NSNumber *count = [movesCountSorted objectAtIndex:i];
        progress += [count intValue] * 4;
    }
    progress += pokemonCount * 18;
    [[PKEPokemonManager sharedManager] setProgress:(progress / 100.0f)];
}

- (void)updateProgress
{
    [self calculateProgress];
    [[self navigationController] setProgress:[[PKEPokemonManager sharedManager] progress]
                                    animated:YES];
}

- (void)addButtonTapped:(id)sender
{
    if ([[PKEPokemonManager sharedManager] isIAPContentAvailable]) {
        [self performSegueWithIdentifier:@"AddSegue"
                                  sender:self];
    }
    else {
        if ([[self dataSource] count] < MAX_POKEMON_BOX_WITHOUT_IAP) {
            [self performSegueWithIdentifier:@"AddSegue"
                                      sender:self];
        }
        else {
            TLAlertView *alertView = [[TLAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:@"You can't save more than six pokémon in your party."
                                      "Remove one first in order to add another or buy unlimited space."
                                      leftButtonTitle:@"OK"
                                      rightButtonTitle:@"Buy"
                                      handler:^(int buttonIndex) {
                                          if (buttonIndex == 0) {
                                              [[PKEPokemonManager sharedManager]
                                               getProductsWithIdentifiers:[NSSet setWithObject:IAP_IDENTIFIER]
                                               completion:^(NSArray *array, NSError *error) {
                                                   if (!error) {
                                                       if ([array count] > 0) {
                                                           [[PKEPokemonManager sharedManager] buyProduct:[array firstObject]];
                                                       }
                                                   }
                                               }];
                                          }
                                      }];
            [alertView show];
        }
    }
}

- (void)chartButtonTapped:(id)sender
{
    if ([[PKEPokemonManager sharedManager] progress] >= 1.0f) {
        UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main"
                                                                                  bundle:nil] instantiateViewControllerWithIdentifier:@"PKEEffectiveViewController"];
        PKEPartySelectionViewController *controller = [[navigationController viewControllers] objectAtIndex:0];
        [controller setBox:[self dataSource]];
        [self presentViewControllerWithFadebackAnimation:navigationController
                                              completion:nil];
    }
    else {
        TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You need at least three pokémon with four moves each one in your box to analyze a party."
                                                        buttonTitle:@"OK"];
        [alertView show];
    }
}

- (void)configureTableViewCell:(PKEMemberCollectionViewCell *)tableViewCell
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

- (void)configureNoContentLabel
{
    UILabel *lblNoContent = [[UILabel alloc] initWithFrame:CGRectZero];
    lblNoContent.backgroundColor = [UIColor clearColor];
    [lblNoContent setNumberOfLines:0];
    [lblNoContent setTextAlignment:NSTextAlignmentCenter];
    [lblNoContent setTextColor:[UIColor colorWithHexString:@"#898C90"]];
    [lblNoContent setText:EMPTY_PARTY];
    [lblNoContent setAlpha:0.0f];
    [[self view] addSubview:lblNoContent];
    [lblNoContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(lblNoContent.superview).with.insets(UIEdgeInsetsMake(50, 50, 50, 50));
    }];
    [self setLblNoContent:lblNoContent];
}

- (void)configureCollectionView
{
    PKEBoxCollectionViewFlowLayout *layout = [[PKEBoxCollectionViewFlowLayout alloc] initWithCoder:nil];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [[self view] addSubview:collectionView];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(onLongPressMemberCell:)];
    [collectionView addGestureRecognizer:recognizer];
    [self setCollectionView:collectionView];
}

- (void)updatePartyWithPokemon:(PKEPokemon *)pokemon
{
    @weakify(self)
    [[self collectionView] performBatchUpdates:^{
        @strongify(self)
        NSMutableArray *mutableDataSource = [[self dataSource] mutableCopy];
        [mutableDataSource addObject:pokemon];
        [self setDataSource:[mutableDataSource copy]];
        [[self collectionView] insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[mutableDataSource count] - 1
                                                                             inSection:0]]];
    } completion:^(BOOL finished) {
        @strongify(self)
        if (finished) {
            [[self collectionView] scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[[self dataSource] count] - 1
                                                                               inSection:0]
                                          atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                                  animated:YES];
            [self updateProgress];
        }
    }];
}

- (void)onLongPressMemberCell:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:[self collectionView]]];
        if (indexPath != nil) {
            [self setSelectedIndexPath:indexPath];
            PKEPokemon *pokemon = [[self dataSource] objectAtIndex:[indexPath row]];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Remove %@ from party?", [pokemon name]]
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:@"Remove"
                                                            otherButtonTitles:nil];
            [actionSheet showInView:[self view]];
        }
    }
}

#pragma mark - PKEMovesetViewControllerDelegate

- (void)shouldCalculateProgress
{
    [self calculateProgress];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MemberCollectionViewCell";
    PKEMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                    forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"MovesetSegue"
                              sender:self];
}

#pragma mark - PKETableViewControllerDelegate

- (void)tableViewControllerDidSelectPokemon:(PKEPokemon *)pokemon
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
                                     [self updatePartyWithPokemon:pokemon];
                                 }
             }];
        }
        else {
            [self updatePartyWithPokemon:pokemon];
        }
    }
    else {
        if ([[error domain] isEqualToString:PKEErrorPokemonDomain]) {
            PKEErrorCodePokemon code = [error code];
            switch (code) {
                case kPKEErrorCodeSavingSamePokemon:
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:@"You can't save the same pokémon twice in your party."
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
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        PKEPokemon *pokemon = [[self dataSource] objectAtIndex:[[self selectedIndexPath] row]];
        [[PKEPokemonManager sharedManager] removePokemonFromBox:pokemon
                                                     completion:^(BOOL result, NSError *error) {
                                                         @weakify(self)
                                                         if (!error) {
                                                             [[self collectionView] performBatchUpdates:^{
                                                                 @strongify(self);
                                                                 if (!error) {
                                                                     NSMutableArray *mutableDataSource = [[self dataSource] mutableCopy];
                                                                     [mutableDataSource removeObject:pokemon];
                                                                     [self setDataSource:[mutableDataSource copy]];
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
                                                                     [self updateProgress];
                                                                 }
                                                             }];
                                                         }
                                                     }];
        
    }
}

@end
