//
//  PKETypeViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PKETypeViewControllerDelegate <NSObject>

- (void)onSelectPokemonType:(PKEPokemonType)pokemonType;

@end

@interface PKETypeViewController : UICollectionViewController

@property (nonatomic, strong) IBOutlet UIBarButtonItem *clearButton;
@property (nonatomic, assign) PKEPokemonType pokemonTypeFiltered;
@property (nonatomic, weak) id<PKETypeViewControllerDelegate> delegate;

- (IBAction)clearButtonTapped:(id)sender;

@end
