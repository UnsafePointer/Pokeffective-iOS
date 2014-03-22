//
//  PKEMoveCell.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKETableViewCell.h"

@interface PKEMoveTableViewCell : PKETableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblCategory;
@property (nonatomic, weak) IBOutlet UILabel *lblDetails;

@end
