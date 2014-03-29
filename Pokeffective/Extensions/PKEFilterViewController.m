//
//  PKEFilterViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEFilterViewController.h"
#import "PKEPokemonManager.h"
#import "PKETypeViewController.h"

@interface PKEFilterViewController () <PKETypeViewControllerDelegate>

@property (nonatomic, strong) NSArray *selectionIndexPaths;
@property (nonatomic, assign) BOOL edited;
@property (nonatomic, assign) PKEPokedexType pokedexTypeFiltered;
@property (nonatomic, assign) PKEMoveMethod moveMethodFiltered;
@property (nonatomic, assign) PKEMoveCategory moveCathegoryFiltered;
@property (nonatomic, assign) PKEPokemonType pokemonTypeFiltered;
@property (nonatomic, assign) BOOL currentlyShowingButtons;

- (void)checkForCurrentModifications;
- (void)showApplyButton;
- (void)showRestoreButton;
- (void)showApplyAndRestoreButtons;
- (void)hideButtons;
- (void)applyButtonTapped:(id)sender;
- (void)restoreButtonTapped:(id)sender;
- (void)checkForPreviousModifications;

@end

@implementation PKEFilterViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setCurrentlyShowingButtons:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch ([self filterType]) {
        case kPKEFilerTypePokemon: {
            PKEPokedexType currentPokedexType = [[PKEPokemonManager sharedManager] filteringPokedexType];
            [self setSelectionIndexPaths:@[[[PKEPokemonManager sharedManager] indexPathForPokedexType:currentPokedexType]]];
            [self setPokedexTypeFiltered:currentPokedexType];
            break;
        }
        case kPKEFilerTypeMoves: {
            PKEMoveMethod currentMoveMethod = [[PKEPokemonManager sharedManager] filteringMoveMethod];
            PKEMoveCategory currentMoveCategory = [[PKEPokemonManager sharedManager] filteringMoveCategory];
            [self setSelectionIndexPaths:@[
                                           [[PKEPokemonManager sharedManager] indexPathForMoveMethod:currentMoveMethod],
                                           [[PKEPokemonManager sharedManager] indexPathForMoveCategory:currentMoveCategory]
                                           ]];
            break;
        }
    }
    PKEPokemonType currentPokemonType = PKEPokemonTypeNone;
    switch ([self filterType]) {
        case kPKEFilerTypePokemon: {
            currentPokemonType = [[PKEPokemonManager sharedManager] filteringPokemonType];
            break;
        }
        case kPKEFilerTypeMoves: {
            currentPokemonType = [[PKEPokemonManager sharedManager] filteringMoveType];
            break;
        }
    }
    [self setPokemonTypeFiltered:currentPokemonType];
    [self checkForPreviousModifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self lblTypeFilter] setText:[[PKEPokemonManager sharedManager] nameForType:[self pokemonTypeFiltered]]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TypeSegue"]) {
        PKETypeViewController *viewController = [segue destinationViewController];
        [viewController setPokemonTypeFiltered:[self pokemonTypeFiltered]];
        [viewController setDelegate:self];
    }
}

#pragma mark - Private Methods

- (void)checkForPreviousModifications
{
    BOOL isModified = NO;
    if ([self filterType] == kPKEFilerTypePokemon) {
        if (PKEPokedexTypeNational != [[PKEPokemonManager sharedManager] filteringPokedexType]) {
            isModified = YES;
        }
        if (PKEPokemonTypeNone != [[PKEPokemonManager sharedManager] filteringPokemonType]) {
            isModified = YES;
        }
    }
    else {
        if (PKEMoveMethodAll != [[PKEPokemonManager sharedManager] filteringMoveMethod]) {
            isModified = YES;
        }
        if (PKEMoveCategoryAll != [[PKEPokemonManager sharedManager] filteringMoveCategory]) {
            isModified = YES;
        }
        if (PKEPokemonTypeNone != [[PKEPokemonManager sharedManager] filteringMoveType]) {
            isModified = YES;
        }
    }
    if (isModified) {
        [self showRestoreButton];
    }
}

- (void)checkForCurrentModifications
{
    BOOL isModified = NO;
    if ([self filterType] == kPKEFilerTypePokemon) {
        if ([self pokedexTypeFiltered] != [[PKEPokemonManager sharedManager] filteringPokedexType]) {
            isModified = YES;
        }
        if ([self pokemonTypeFiltered] != [[PKEPokemonManager sharedManager] filteringPokemonType]) {
            isModified = YES;
        }
    }
    else {
        if ([self moveMethodFiltered] != [[PKEPokemonManager sharedManager] filteringMoveMethod]) {
            isModified = YES;
        }
        if ([self moveCathegoryFiltered] != [[PKEPokemonManager sharedManager] filteringMoveCategory]) {
            isModified = YES;
        }
        if ([self pokemonTypeFiltered] != [[PKEPokemonManager sharedManager] filteringMoveType]) {
            isModified = YES;
        }
    }
    if (isModified) {
        if (![self currentlyShowingButtons]) {
            [self showApplyAndRestoreButtons];
        }
    }
    else {
        if ([self currentlyShowingButtons]) {
            [self hideButtons];
        }
    }
}

- (void)showRestoreButton
{
    UIBarButtonItem *restoreBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Trash"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(restoreButtonTapped:)];
    [self.navigationItem setRightBarButtonItems:@[restoreBarButtonItem] animated:YES];
    [self setCurrentlyShowingButtons:NO];
}

- (void)showApplyAndRestoreButtons
{
    UIBarButtonItem *applyBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Apply"]
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:@selector(applyButtonTapped:)];
    UIBarButtonItem *restoreBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Trash"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(restoreButtonTapped:)];
    [self.navigationItem setRightBarButtonItems:@[applyBarButtonItem, restoreBarButtonItem] animated:YES];
    [self setCurrentlyShowingButtons:YES];
}

- (void)hideButtons
{
    [self.navigationItem setRightBarButtonItems:nil animated:YES];
    [self setCurrentlyShowingButtons:NO];
}

- (void)applyButtonTapped:(id)sender
{
    if ([self filterType] == kPKEFilerTypePokemon) {
        [[PKEPokemonManager sharedManager] setFilteringPokedexType:[self pokedexTypeFiltered]];
        [[PKEPokemonManager sharedManager] setFilteringPokemonType:[self pokemonTypeFiltered]];
    }
    else {
        [[PKEPokemonManager sharedManager] setFilteringMoveType:[self pokemonTypeFiltered]];
        [[PKEPokemonManager sharedManager] setFilteringMoveMethod:[self moveMethodFiltered]];
        [[PKEPokemonManager sharedManager] setFilteringMoveCategory:[self moveCathegoryFiltered]];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)restoreButtonTapped:(id)sender
{
    if ([self filterType] == kPKEFilerTypePokemon) {
        [[PKEPokemonManager sharedManager] setFilteringPokedexType:PKEPokedexTypeNational];
        [[PKEPokemonManager sharedManager] setFilteringPokemonType:PKEPokemonTypeNone];
    }
    else {
        [[PKEPokemonManager sharedManager] setFilteringMoveType:PKEPokemonTypeNone];
        [[PKEPokemonManager sharedManager] setFilteringMoveMethod:PKEMoveMethodAll];
        [[PKEPokemonManager sharedManager] setFilteringMoveCategory:PKEMoveCategoryAll];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - PKETypeViewControllerDelegate

- (void)onSelectPokemonType:(PKEPokemonType)pokemonType
{
    [self setPokemonTypeFiltered:pokemonType];
    [self checkForCurrentModifications];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    for (NSIndexPath *selectionIndexPath in [self selectionIndexPaths]) {
        if ([indexPath section] == [selectionIndexPath section] &&
            [indexPath row] == [selectionIndexPath row]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section + 1) != [self numberOfSectionsInTableView:tableView]) {
        switch ([self filterType]) {
            case kPKEFilerTypePokemon: {
                PKEPokedexType pokedexType = [[PKEPokemonManager sharedManager] pokedexTypeForIndexPath:indexPath];
                [self setPokedexTypeFiltered:pokedexType];
                break;
            }
            case kPKEFilerTypeMoves: {
                if ([indexPath section] == 0) {
                    PKEMoveMethod moveMethod = [[PKEPokemonManager sharedManager] moveMethodForIndexPath:indexPath];
                    [self setMoveMethodFiltered:moveMethod];
                }
                else {
                    PKEMoveCategory moveCategory = [[PKEPokemonManager sharedManager] moveCategoryForIndexPath:indexPath];
                    [self setMoveCathegoryFiltered:moveCategory];
                }
                break;
            }
        }
        [self checkForCurrentModifications];
        UITableViewCell *currentSelectionCell = [[self tableView] cellForRowAtIndexPath:[[self selectionIndexPaths] objectAtIndex:[indexPath section]]];
        currentSelectionCell.accessoryType = UITableViewCellAccessoryNone;
        UITableViewCell *selectionCell = [[self tableView] cellForRowAtIndexPath:indexPath];
        selectionCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
        NSMutableArray *selections = [[self selectionIndexPaths] mutableCopy];
        [selections replaceObjectAtIndex:[indexPath section] withObject:indexPath];
        [self setSelectionIndexPaths:[selections copy]];
        [[self tableView] reloadData];
    }
}

@end
