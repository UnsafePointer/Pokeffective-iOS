//
//  PKEMovesetViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKEMoveCollectionViewController.h"

@protocol PKEMovesetViewControllerDelegate <NSObject>

- (void)shouldCalculateProgress;

@end

@class PKEPokemon;

@interface PKEMovesetViewController : PKEMoveCollectionViewController

@property (nonatomic, weak) id<PKEMovesetViewControllerDelegate> delegate;

- (IBAction)onTapAddButton:(id)sender;

@end
