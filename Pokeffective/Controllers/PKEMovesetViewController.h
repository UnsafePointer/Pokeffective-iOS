//
//  PKEMovesetViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKEPokemon;

@interface PKEMovesetViewController : UICollectionViewController

@property (nonatomic, strong) PKEPokemon *pokemon;

- (IBAction)onLongPressMoveCell:(id)sender;

@end
