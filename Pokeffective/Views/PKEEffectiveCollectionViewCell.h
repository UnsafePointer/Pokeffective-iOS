//
//  PKEEffectiveCell.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKECollectionViewCell.h"

@interface PKEEffectiveCollectionViewCell : PKECollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblType;
@property (nonatomic, weak) IBOutlet UILabel *lblEffective;
@property (nonatomic, weak) IBOutlet UIImageView *imgViewDisclosure;

@end
