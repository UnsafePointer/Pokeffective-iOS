//
//  PKELabel.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKELabel.h"

@interface PKELabel ()

@property (nonatomic) UIEdgeInsets edgeInsets;

@end

@implementation PKELabel

- (id)initWithFrame:(CGRect)frame
      andEdgeInsets:(UIEdgeInsets)edgeInsets
{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = edgeInsets;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
