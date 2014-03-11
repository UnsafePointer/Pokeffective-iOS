//
//  PKEMove.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEMove.h"

@implementation PKEMove

+ (PKEMove *)createMoveWithDictionary:(NSDictionary *)dictionary;
{
    PKEMove *move = [PKEMove new];
    [move setName:[dictionary objectForKey:@"Name"]];
    [move setType:[dictionary objectForKey:@"Type"]];
    [move setCategory:[dictionary objectForKey:@"Category"]];
    [move setPower:[dictionary objectForKey:@"Power"]];
    [move setAccuracy:[dictionary objectForKey:@"Accuracy"]];
    return move;
}

@end
