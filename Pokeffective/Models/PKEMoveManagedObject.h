//
//  PKEMoveManagedObject.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PKEPokemonManagedObject;

@interface PKEMoveManagedObject : NSManagedObject

@property (nonatomic, retain) NSNumber * accuracy;
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) PKEPokemonManagedObject *pokemon;

@end
