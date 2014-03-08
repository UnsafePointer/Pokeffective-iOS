//
//  PKEPokemonCell.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPokemonCell.h"

@implementation PKEPokemonCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundView:[[UIView alloc] initWithFrame:self.bounds]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setBackgroundView:[[UIView alloc] initWithFrame:self.bounds]];
    }
    return self;
}

- (void)addCustomLayerToContentView
{
    CAGradientLayer *backgroundGradient = [CAGradientLayer layer];
    backgroundGradient.frame = self.bounds;
    backgroundGradient.colors = [NSArray arrayWithObjects:(__bridge id)[[UIColor blackColor] CGColor],
                                 (__bridge id)[[UIColor whiteColor] CGColor],
                                 nil];
    [self.contentView.layer insertSublayer:backgroundGradient
                                   atIndex:0];
//    CAGradientLayer *selectedBackgroundGradient = [CAGradientLayer layer];
//    selectedBackgroundGradient.frame = self.bounds;
//    selectedBackgroundGradient.colors = [NSArray arrayWithObjects:(__bridge id)[[UIColor whiteColor] CGColor],
//                                         (__bridge id)[[UIColor blackColor] CGColor],
//                                         nil];
//    [self.selectedBackgroundView.layer insertSublayer:selectedBackgroundGradient
//                                              atIndex:0];
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected
              animated:animated];
}

@end
