//
//  PKEPokemonCollectionViewCell.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKECollectionViewCell.h"

@interface PKEPokemonCollectionViewCell : PKECollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblTypes;
@property (nonatomic, weak) IBOutlet UILabel *lblNumber;
@property (nonatomic, weak) IBOutlet UIImageView *imgPicture;

@end
