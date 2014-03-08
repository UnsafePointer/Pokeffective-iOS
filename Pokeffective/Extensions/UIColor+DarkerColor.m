//
//  UIColor+DarkerColor.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "UIColor+DarkerColor.h"

@implementation UIColor (DarkerColor)

- (UIColor *)darkerColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r
               green:&g
                blue:&b
               alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

@end
