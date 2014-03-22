//
//  PKEMovesetViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKEMoveCollectionViewController.h"

@class PKEPokemon;

@interface PKEMovesetViewController : PKEMoveCollectionViewController

- (IBAction)onLongPressMoveCell:(id)sender;

@end
