//
//  PKEMoveCollectionViewCell.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKECollectionViewCell.h"

@interface PKEMoveCollectionViewCell : PKECollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblCategory;
@property (nonatomic, weak) IBOutlet UILabel *lblDetails;

@end
