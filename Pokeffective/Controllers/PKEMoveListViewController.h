//
//  PKEMoveListViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKEMoveCollectionViewController.h"
#import "PKEMoveControllerDelegate.h"

@interface PKEMoveListViewController : PKEMoveCollectionViewController

@property (nonatomic, weak) id<PKEMoveControllerDelegate> delegate;

@end
