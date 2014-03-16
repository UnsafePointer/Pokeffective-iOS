//
//  PKEMoveTableViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 16/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKEMove;
@class PKEPokemon;

@protocol PKEMoveTableViewControllerDataSource <UITableViewDataSource>

@optional

- (PKEMove *)getMoveForIndexPath:(NSIndexPath *)indexPath
                     inTableView:(UITableView *)tableView;

@end

@protocol PKEMoveTableViewControllerDelegate <NSObject>

- (void)tableViewControllerDidSelectMove:(PKEMove *)move
                                   error:(NSError *)error;

@end

@interface PKEMoveTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) PKEPokemon *pokemon;
@property (nonatomic, weak) id<PKEMoveTableViewControllerDelegate> delegate;

@end
