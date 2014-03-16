//
//  PKETypeViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKEPokemonTypeViewController : UICollectionViewController

@property (nonatomic, strong) IBOutlet UIBarButtonItem *clearButton;

- (IBAction)clearButtonTapped:(id)sender;

@end
