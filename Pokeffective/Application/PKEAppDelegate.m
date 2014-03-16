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

@end

@implementation PKEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [self setNavigationBarAppearance];
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
            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ffffff"]
    }];
}

@end
