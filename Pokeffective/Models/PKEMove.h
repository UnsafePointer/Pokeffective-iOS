//
//  PKEMove.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 11/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKEMove : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSNumber *power;
@property (nonatomic, copy) NSNumber *accuracy;

+ (PKEMove *)createMoveWithDictionary:(NSDictionary *)dictionary;

@end
