//
//  PKEPartySelectionViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 30/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPartySelectionViewController.h"
#import "PKEPartyCollectionViewFlowLayout.h"
#import "PKEPokemon.h"
#import "PKEPartySelectionCollectionViewCell.h"
#import "PKEPokemonManager.h"
#import "PKEMove.h"
#import "TLAlertView.h"
#import "PKEEffectiveViewController.h"

@interface PKEPartySelectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL currentlyShowingRestoreButton;
@property (nonatomic, assign) BOOL currentlyShowingBothButtons;
@property (nonatomic, assign) PKEAnalysisType analysisTypeSelected;

- (void)filterDataSource;
- (void)configureCollectionView;
- (void)configureTableViewCell:(PKEPartySelectionCollectionViewCell *)collectionViewCell
                  forIndexPath:(NSIndexPath *)indexPath;
- (void)updateProgress;
- (void)applyButtonTapped:(id)sender;
- (void)restoreButtonTapped:(id)sender;

@end

@implementation PKEPartySelectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setCurrentlyShowingRestoreButton:NO];
        [self setCurrentlyShowingBothButtons:NO];
        [self setAnalysisTypeSelected:PKEAnalysisTypeNone];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self filterDataSource];
    [self configureCollectionView];
    UINib *nib = [UINib nibWithNibName:@"PKEPartySelectionCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [[self collectionView] registerNib:nib
            forCellWithReuseIdentifier:@"PartySelectionCollectionViewCell"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EffectiveSegue"]) {
        NSMutableArray *party = [[NSMutableArray alloc] init];
        for (NSIndexPath *indexPath in [[self collectionView] indexPathsForSelectedItems]) {
            [party addObject:[[self dataSource] objectAtIndex:[indexPath row]]];
        }
        PKEEffectiveViewController *controller = [segue destinationViewController];
        [controller setAnalysisType:[self analysisTypeSelected]];
        [controller setParty:party];
    }
}

#pragma mark - Public Methods

- (IBAction)onTapExitButton:(id)sender
{
    [self dismissViewControllerWithFadebackAnimationCompletion:nil];
}

#pragma mark - Private Methods

- (void)applyButtonTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an option to begging the analysis"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Attacking", @"Defending", nil];
    [actionSheet showInView:[self view]];
}

- (void)restoreButtonTapped:(id)sender
{
    for (NSIndexPath *indexPath in [[self collectionView] indexPathsForSelectedItems]) {
        [[self collectionView] deselectItemAtIndexPath:indexPath animated:YES];
    }
    [self updateProgress];
}

- (void)updateProgress
{
    CGFloat progress = [[[self collectionView] indexPathsForSelectedItems] count] * 33.4f;
    [[self navigationController] setProgress:progress/100.0f
                                    animated:YES];
    if (progress > 100.0f) {
        if (![self currentlyShowingBothButtons]) {
            UIBarButtonItem *applyBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Apply"]
                                                                                   style:UIBarButtonItemStyleBordered
                                                                                  target:self
                                                                                  action:@selector(applyButtonTapped:)];
            UIBarButtonItem *restoreBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Trash"]
                                                                                     style:UIBarButtonItemStyleBordered
                                                                                    target:self
                                                                                    action:@selector(restoreButtonTapped:)];
            [self.navigationItem setRightBarButtonItems:@[applyBarButtonItem, restoreBarButtonItem]
                                               animated:YES];
            [self setCurrentlyShowingBothButtons:YES];
            [self setCurrentlyShowingRestoreButton:NO];
        }
    }
    else if (progress > 0) {
        if (![self currentlyShowingRestoreButton]) {
            UIBarButtonItem *restoreBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Trash"]
                                                                                     style:UIBarButtonItemStyleBordered
                                                                                    target:self
                                                                                    action:@selector(restoreButtonTapped:)];
            [self.navigationItem setRightBarButtonItems:@[restoreBarButtonItem]
                                               animated:YES];
            [self setCurrentlyShowingRestoreButton:YES];
            [self setCurrentlyShowingBothButtons:NO];
        }
    }
    else {
        if ([self currentlyShowingBothButtons] || [self currentlyShowingRestoreButton]) {
            [self.navigationItem setRightBarButtonItems:nil
                                               animated:YES];
            [self setCurrentlyShowingBothButtons:NO];
            [self setCurrentlyShowingRestoreButton:NO];
        }
    }
}

- (void)filterDataSource
{
    NSMutableArray *dataSource = [NSMutableArray array];
    for (PKEPokemon *pokemon in [self box]) {
        if ([[pokemon moves] count] >= 4) {
            [dataSource addObject:pokemon];
        }
    }
    [self setDataSource:[dataSource copy]];
}

- (void)configureCollectionView
{
    PKEPartyCollectionViewFlowLayout *layout = [[PKEPartyCollectionViewFlowLayout alloc] initWithCoder:nil];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [[self view] addSubview:collectionView];
    [collectionView setAllowsMultipleSelection:YES];
    [self setCollectionView:collectionView];
}

- (void)configureTableViewCell:(PKEPartySelectionCollectionViewCell *)collectionViewCell
                  forIndexPath:(NSIndexPath *)indexPath
{
    [[collectionViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEPokemon *pokemon = [[self dataSource] objectAtIndex:[indexPath row]];
    NSArray *labels = @[[collectionViewCell lblFirstMove], [collectionViewCell lblSecondMove], [collectionViewCell lblThirdMove], [collectionViewCell lblFourthMove]];
    int i = 0;
    for (PKEMove *move in [pokemon moves]) {
        UILabel *label = labels[i];
        [label setText:[move name]];
        i++;
    }
    [[collectionViewCell imgPicture] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d.png", [pokemon identifier]]]];
    if ([pokemon secondType] == PKEPokemonTypeNone) {
        [collectionViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]];
    }
    else {
        [collectionViewCell addBackgroundLayersWithFirstColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]
                                             secondColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon secondType]]];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self setAnalysisTypeSelected:PKEAnalysisTypeAttack];
        [self performSegueWithIdentifier:@"EffectiveSegue"
                                  sender:self];
    }
    else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
        [self setAnalysisTypeSelected:PKEAnalysisTypeDefense];
        [self performSegueWithIdentifier:@"EffectiveSegue"
                                  sender:self];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PartySelectionCollectionViewCell";
    PKEPartySelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                  forIndexPath:indexPath];
    [self configureTableViewCell:cell
                    forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self collectionView] indexPathsForSelectedItems] count] > 3) {
        [[self collectionView] deselectItemAtIndexPath:indexPath
                                              animated:YES];
        TLAlertView *alertView = [[TLAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"You can't analize a party with more than three pokémon."
                                  buttonTitle:@"OK"];
        [alertView show];
    }
    else {
        [self updateProgress];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateProgress];
}

@end
