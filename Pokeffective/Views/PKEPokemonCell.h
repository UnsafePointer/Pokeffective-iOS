//
//  PKEPokemonCell.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKEPokemonCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblTypes;
@property (nonatomic, weak) IBOutlet UILabel *lblNumber;
@property (nonatomic, weak) IBOutlet UIImageView *imgPicture;

- (void)addCustomLayerToContentView;

@end
