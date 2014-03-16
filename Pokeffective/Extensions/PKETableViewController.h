//
//  PKETableViewController.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKEPokemon;

@protocol PKETableViewControllerDataSource <UITableViewDataSource>

@optional

- (PKEPokemon *)getPokemonForIndexPath:(NSIndexPath *)indexPath
                           inTableView:(UITableView *)tableView;

@end

@protocol PKETableViewControllerDelegate <NSObject>

- (void)tableViewControllerDidSelectPokemon:(PKEPokemon *)pokemon
                                      error:(NSError *)error;

@end

@interface PKETableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id<PKETableViewControllerDelegate> delegate;

@end
