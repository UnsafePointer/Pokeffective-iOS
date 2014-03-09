//
//  PKEPartyViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPartyViewController.h"

@interface PKEPartyViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)addButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"AddSegue"
                              sender:self];
}

- (void)chartButtonTapped:(id)sender
{
    
}

@end
