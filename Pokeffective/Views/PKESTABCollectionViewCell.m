//
//  PKESTABerCollectionViewCell.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKESTABCollectionViewCell.h"

@implementation PKESTABCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder]) {
        [[self layer] setCornerRadius:5.0f];
        [[self layer] setMasksToBounds:YES];
    }
    return self;
}

@end
