//
//  PKEMoveListViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKEMoveTableViewController.h"

@interface PKEMoveListViewController : UICollectionViewController

@property (nonatomic, strong) PKEPokemon *pokemon;
@property (nonatomic, weak) id<PKEMoveTableViewControllerDelegate> delegate;

@end
