//
//  PKECollectionViewCell.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKECollectionViewCell.h"
#import "UIColor+PKEDarkerColor.h"

@interface PKECollectionViewCell ()

- (void)checkAndRemovePreviousLayers;

@end

@implementation PKECollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setBackgroundView:[[UIView alloc] initWithFrame:self.bounds]];
        [self setSelectedBackgroundView:[[UIView alloc] initWithFrame:self.bounds]];
    }
    return self;
}

- (void)checkAndRemovePreviousLayers
{
    if (self.backgroundView.layer.sublayers) {
        for (CALayer *layer in self.backgroundView.layer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
    if (self.selectedBackgroundView.layer.sublayers) {
        for (CALayer *layer in self.selectedBackgroundView.layer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
}

- (void)addBackgroundLayersWithColor:(UIColor *)color
{
    [self checkAndRemovePreviousLayers];
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.backgroundColor = [color CGColor];
    backgroundLayer.frame = self.bounds;
    [self.backgroundView.layer insertSublayer:backgroundLayer
                                      atIndex:0];
    CALayer *selectedBackgroundLayer = [CALayer layer];
    selectedBackgroundLayer.backgroundColor = [[color PKE_darkerColor] CGColor];
    selectedBackgroundLayer.frame = self.bounds;
    [self.selectedBackgroundView.layer insertSublayer:selectedBackgroundLayer
                                              atIndex:0];
}

- (void)addBackgroundLayersWithFirstColor:(UIColor *)firstColor
                              secondColor:(UIColor *)secondColor
{
    [self checkAndRemovePreviousLayers];
    CAGradientLayer *backgroundGradient = [CAGradientLayer layer];
    backgroundGradient.startPoint = CGPointMake(0, 0.5);
    backgroundGradient.endPoint = CGPointMake(1.0, 0.5);
    backgroundGradient.frame = self.bounds;
    backgroundGradient.colors = [NSArray arrayWithObjects:(__bridge id)[firstColor CGColor],
                                 (__bridge id)[secondColor CGColor],
                                 nil];
    [self.backgroundView.layer insertSublayer:backgroundGradient
                                      atIndex:0];
    CAGradientLayer *selectedBackgroundGradient = [CAGradientLayer layer];
    selectedBackgroundGradient.startPoint = CGPointMake(0, 0.5);
    selectedBackgroundGradient.endPoint = CGPointMake(1.0, 0.5);
    selectedBackgroundGradient.frame = self.bounds;
    selectedBackgroundGradient.colors = [NSArray arrayWithObjects:(__bridge id)[[firstColor PKE_darkerColor] CGColor],
                                         (__bridge id)[[secondColor PKE_darkerColor] CGColor],
                                         nil];
    [self.selectedBackgroundView.layer insertSublayer:selectedBackgroundGradient
                                              atIndex:0];
}


@end
