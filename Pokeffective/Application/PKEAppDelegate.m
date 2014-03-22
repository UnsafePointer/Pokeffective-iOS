//
//  PKEAppDelegate.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 05/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEAppDelegate.h"

@interface PKEAppDelegate ()

- (void)setNavigationBarAppearance;
- (void)setTabBarAppearance;

@end

@implementation PKEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [self setNavigationBarAppearance];
    [self setTabBarAppearance];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

#pragma mark - Private Methods

- (void)setNavigationBarAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:@[[UIColor colorWithHexString:@"#1AD6FD"],
            [UIColor colorWithHexString:@"#1D62F0"]]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#ffffff"]
    }];
}

- (void)setTabBarAppearance
{
    UITabBarController *tabBarController = (UITabBarController *)[[self window] rootViewController];
    UITabBarItem *partyTabBarItem = [[[tabBarController tabBar] items] objectAtIndex:0];
    UITabBarItem *onlineTabBarItem = [[[tabBarController tabBar] items] objectAtIndex:1];
    partyTabBarItem.image = [[UIImage imageNamed:@"Party"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    onlineTabBarItem.image = [[UIImage imageNamed:@"Online"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    partyTabBarItem.selectedImage = [UIImage imageNamed:@"Party-Selected"];
    onlineTabBarItem.selectedImage = [UIImage imageNamed:@"Online-Selected"];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateNormal];
}

@end
