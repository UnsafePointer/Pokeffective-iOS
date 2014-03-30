//
//  PKEPartySelectionCollectionViewCell.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 30/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKECollectionViewCell.h"

@interface PKEPartySelectionCollectionViewCell : PKECollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblFirstMove;
@property (nonatomic, weak) IBOutlet UILabel *lblSecondMove;
@property (nonatomic, weak) IBOutlet UILabel *lblThirdMove;
@property (nonatomic, weak) IBOutlet UILabel *lblFourthMove;
@property (nonatomic, weak) IBOutlet UIImageView *imgPicture;
@property (nonatomic, weak) IBOutlet UIImageView *imgApply;

@end
