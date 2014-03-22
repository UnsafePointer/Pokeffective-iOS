//
//  PKEMoveControllerDelegate.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKEMove;

@protocol PKEMoveControllerDelegate <NSObject>

- (void)controllerDidSelectMove:(PKEMove *)move
                          error:(NSError *)error;

@end
