//
//  PKEEffectiveViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKEEffectiveViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *party;

- (IBAction)onTapExitButton:(id)sender;

@end
