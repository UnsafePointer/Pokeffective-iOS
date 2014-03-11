//
//  PKEDataBaseManager.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKEDataBaseManager : NSObject

+ (instancetype)sharedManager;
- (NSArray *)getPokemons;
- (NSArray *)getParty;
- (NSArray *)getMoveset;
- (UIColor *)getColorForType:(NSString *)type;

@end
