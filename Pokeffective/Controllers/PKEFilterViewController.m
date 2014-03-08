//
//  PKEFilterViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 08/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEFilterViewController.h"

@interface PKEFilterViewController ()

@property (nonatomic, strong) NSIndexPath *selectionIndexPath;

@end

@implementation PKEFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSelectionIndexPath:[NSIndexPath indexPathForRow:0
                                                   inSection:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *currentSelectionCell = [[self tableView] cellForRowAtIndexPath:[self selectionIndexPath]];
        currentSelectionCell.accessoryType = UITableViewCellAccessoryNone;
        UITableViewCell *selectionCell = [[self tableView] cellForRowAtIndexPath:indexPath];
        selectionCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
        [self setSelectionIndexPath:indexPath];
    }
}

#pragma mark - Public Methods

- (IBAction)exitFromTypeSelection:(UIStoryboardSegue *)unwindSegue
{

}

@end
