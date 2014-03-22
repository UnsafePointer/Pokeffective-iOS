//
//  PKEMoveCollectionViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 22/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKEMove;
@class PKEPokemon;

@protocol PKEMoveCollectionViewControllerDataSource

@optional

- (PKEMove *)getMoveForIndexPath:(NSIndexPath *)indexPath
                inCollectionView:(UICollectionView *)collectionView;

@end

@interface PKEMoveCollectionViewController : UICollectionViewController <PKEMoveCollectionViewControllerDataSource>

@property (nonatomic, strong) PKEPokemon *pokemon;
@property (nonatomic, strong) NSArray *dataSource;

@end
