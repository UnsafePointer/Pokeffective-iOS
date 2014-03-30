//
//  PKEPartySelectionCollectionViewCell.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 30/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEPartySelectionCollectionViewCell.h"

@implementation PKEPartySelectionCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder]) {
        [[self layer] setCornerRadius:5.0f];
        [[self layer] setMasksToBounds:YES];
    }
    return self;
}

@end
