//
//  PKESearchViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 05/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKEPokemonTableViewController.h"

@interface PKEPokemonListViewController : UIViewController

@property (nonatomic, weak) id<PKEPokemonTableViewControllerDelegate> delegate;

@end
