//
//  Blocks.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 15/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

typedef void (^CompletionBlock)(NSError *error);

typedef void (^BooleanCompletionBlock)(BOOL result, NSError *error);

typedef void (^ObjectCompletionBlock)(id object, NSError *error);

typedef void (^ArrayCompletionBlock)(NSArray *array, NSError *error);
