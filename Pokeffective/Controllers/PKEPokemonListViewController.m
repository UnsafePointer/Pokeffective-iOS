//
//  PKESearchViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 05/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPokemonListViewController.h"
#import "PKEPokemonManager.h"
#import "PKEPokemonTableViewCell.h"
#import "PKEPokemon.h"
#import "PKEPokemonSearchViewController.h"
#import "PKEFilterViewController.h"
#import "PKEPokemonCollectionViewCell.h"
#import "PKEPokemonCollectionViewFlow.h"
#import "TLAlertView.h"

@interface PKEPokemonListViewController () <PKEPokemonTableViewControllerDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) UILabel *lblNoContent;

- (void)searchButtonTapped:(id)sender;
- (void)filterButtonTapped:(id)sender;
- (void)configureNoContentLabel;
- (void)configureCollectionView;
- (void)configureCollectionViewCell:(PKEPokemonCollectionViewCell *)tableViewCell
                       forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PKEPokemonListViewController

static void * PKEPokemonListViewControllerContext = &PKEPokemonListViewControllerContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureNoContentLabel];
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(searchButtonTapped:)];
    UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Filter"]
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(filterButtonTapped:)];
    [self.navigationItem setRightBarButtonItems:@[searchBarButtonItem, filterBarButtonItem]];
    UINib *nib = [UINib nibWithNibName:@"PKEPokemonCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [[self collectionView] registerNib:nib
            forCellWithReuseIdentifier:@"PokemonCollectionViewCell"];
    [[PKEPokemonManager sharedManager] addObserver:self
                                        forKeyPath:NSStringFromSelector(@selector(filteringPokedexType))
                                           options:NSKeyValueObservingOptionNew
                                           context:PKEPokemonListViewControllerContext];
    [[PKEPokemonManager sharedManager] addObserver:self
                                        forKeyPath:NSStringFromSelector(@selector(filteringPokemonType))
                                           options:NSKeyValueObservingOptionNew
                                           context:PKEPokemonListViewControllerContext];
    [SVProgressHUD show];
    [[PKEPokemonManager sharedManager] getPokemonsWithCompletion:^(NSArray *array, NSError *error) {
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [SVProgressHUD dismiss];
            [self setDataSource:array];
            if ([[self dataSource] count] == 0) {
                [[self lblNoContent] setAlpha:1.0f];
            }
            else {
                [[self collectionView] reloadData];
            }
        });
        
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == PKEPokemonListViewControllerContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(filteringPokedexType))] ||
            [keyPath isEqualToString:NSStringFromSelector(@selector(filteringPokemonType))]) {
            [[PKEPokemonManager sharedManager] getPokemonsWithCompletion:^(NSArray *array, NSError *error) {
                @weakify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self setDataSource:array];
                    [[self collectionView] reloadData];
                    if ([[self dataSource] count] == 0) {
                        [[self lblNoContent] setAlpha:1.0f];
                    }
                    else {
                        [[self lblNoContent] setAlpha:0.0f];
                    }
                });
            }];
        }
    }
}

- (void)dealloc
{
    [[PKEPokemonManager sharedManager] removeObserver:self
                                           forKeyPath:NSStringFromSelector(@selector(filteringPokedexType))];
    [[PKEPokemonManager sharedManager] removeObserver:self
                                           forKeyPath:NSStringFromSelector(@selector(filteringPokemonType))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        PKEPokemonSearchViewController *searchViewController = [segue destinationViewController];
        searchViewController.delegate = self.delegate;
        [searchViewController setDataSource:[self dataSource]];
    }
    if ([[segue identifier] isEqualToString:@"FilterSegue"]) {
        PKEFilterViewController *filterViewController = [segue destinationViewController];
        filterViewController.filterType = kPKEFilerTypePokemon;
    }
}

#pragma mark - Private Methods

- (void)searchButtonTapped:(id)sender
{
    if ([[self dataSource] count] > 0) {
        [self performSegueWithIdentifier:@"SearchSegue"
                                  sender:self];
    }
    else {
        TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please, try other filter values first."
                                                        buttonTitle:@"OK"];
        [alertView show];
    }
}

- (void)filterButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"FilterSegue"
                              sender:self];
}

- (void)configureCollectionView
{
    PKEPokemonCollectionViewFlow *layout = [[PKEPokemonCollectionViewFlow alloc] initWithCoder:nil];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [[self view] addSubview:collectionView];
    [self setCollectionView:collectionView];
}

- (void)configureNoContentLabel
{
    UILabel *lblNoContent = [[UILabel alloc] initWithFrame:CGRectZero];
    [lblNoContent setNumberOfLines:0];
    [lblNoContent setText:EMPTY_RESULTS];
    [lblNoContent setTextAlignment:NSTextAlignmentCenter];
    [lblNoContent setTextColor:[UIColor colorWithHexString:@"#898C90"]];
    [lblNoContent setAlpha:0.0f];
    [[self view] addSubview:lblNoContent];
    [lblNoContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(lblNoContent.superview).with.insets(UIEdgeInsetsMake(50, 50, 50, 50));
    }];
    [self setLblNoContent:lblNoContent];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PokemonCollectionViewCell";
    PKEPokemonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                   forIndexPath:indexPath];
    [self configureCollectionViewCell:cell
                         forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PKEPokemon *pokemon = [self getPokemonForIndexPath:indexPath];
    @weakify(self);
    [[PKEPokemonManager sharedManager] addPokemonToBox:pokemon
                                            completion:^(BOOL result, NSError *error) {
                                                @strongify(self);
                                                if ([[self delegate] respondsToSelector:@selector(tableViewControllerDidSelectPokemon:error:)]) {
                                                    [[self delegate] performSelector:@selector(tableViewControllerDidSelectPokemon:error:)
                                                                          withObject:[pokemon copy]
                                                                          withObject:error];
                                                }
                                                [[self navigationController] popToRootViewControllerAnimated:YES];
                                            }];
}

#pragma mark - Private Methods

- (void)configureCollectionViewCell:(PKEPokemonCollectionViewCell *)tableViewCell
                       forIndexPath:(NSIndexPath *)indexPath
{
    [[tableViewCell contentView] setBackgroundColor:[UIColor clearColor]];
    PKEPokemon *pokemon = [self getPokemonForIndexPath:indexPath];
    [[tableViewCell lblName] setText:[pokemon name]];
    [[tableViewCell lblNumber] setText:[NSString stringWithFormat:@"%03d", [pokemon pokedexNumber]]];
    [[tableViewCell imgPicture] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d.png", [pokemon identifier]]]];
    if ([pokemon secondType] == PKEPokemonTypeNone) {
        [[tableViewCell lblTypes] setText:[[PKEPokemonManager sharedManager] nameForType:[pokemon firstType]]];
        [tableViewCell addBackgroundLayersWithColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]];
    }
    else {
        [[tableViewCell lblTypes] setText:[NSString stringWithFormat:@"%@ / %@", [[PKEPokemonManager sharedManager] nameForType:[pokemon firstType]],  [[PKEPokemonManager sharedManager] nameForType:[pokemon secondType]]]];
        [tableViewCell addBackgroundLayersWithFirstColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon firstType]]
                                             secondColor:[[PKEPokemonManager sharedManager] colorForType:[pokemon secondType]]];
    }
}

#pragma mark - PKEPokemonTableViewControllerDataSource

- (PKEPokemon *)getPokemonForIndexPath:(NSIndexPath *)indexPath
{
    return [[self dataSource] objectAtIndex:[indexPath row]];
}

@end
