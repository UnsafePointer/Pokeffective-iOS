//
//  PKEMove.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEMove.h"

@implementation PKEMove

+ (PKEMove *)createMoveWithResultSet:(FMResultSet *)resultSet
{
    PKEMove *move = [PKEMove new];
    [move setType:[resultSet intForColumn:@"type"]];
    [move setName:[[resultSet stringForColumn:@"name"] capitalizedString]];
    [move setCategory:[resultSet intForColumn:@"category"]];
    [move setPower:[resultSet intForColumn:@"power"]];
    [move setAccuracy:[resultSet intForColumn:@"accuracy"]];
    return move;
}

#pragma mark - MTLManagedObjectSerializing

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             @"type" : @"type",
             @"name" : @"name",
             @"category" : @"category",
             @"power" : @"power",
             @"accuracy" : @"accuracy"
            };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             @"pokemon" : @"PKEPokemonManagedObject",
            };
}

+ (NSString *)managedObjectEntityName
{
    return @"PKEMoveManagedObject";
}

@end
