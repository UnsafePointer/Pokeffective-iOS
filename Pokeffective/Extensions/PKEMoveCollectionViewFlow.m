//
//  PKEMoveCollectionViewFlow.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEMoveCollectionViewFlow.h"

@implementation PKEMoveCollectionViewFlow

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.itemSize = CGSizeMake(300, 65);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

@end
