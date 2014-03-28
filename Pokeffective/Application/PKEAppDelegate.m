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
- (void)configureHockeyApp;

@end

@implementation PKEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [self setNavigationBarAppearance];
    [self setTabBarAppearance];
    [self configureHockeyApp];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if( [[[BITHockeyManager sharedHockeyManager] authenticator] handleOpenURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation]) {
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods

- (void)configureHockeyApp
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"985be260844cf58133850a264ae0466a"];
    [[[BITHockeyManager sharedHockeyManager] authenticator] setIdentificationType:BITAuthenticatorIdentificationTypeDevice];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[[BITHockeyManager sharedHockeyManager] authenticator] authenticateInstallation];
}

- (void)setNavigationBarAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:@[[UIColor colorWithHexString:@"#1AD6FD"],
            [UIColor colorWithHexString:@"#1D62F0"]]];
    [[CRGradientNavigationBar appearance] setTitleTextAttributes:@{
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
    partyTabBarItem.selectedImage = [[UIImage imageNamed:@"Party-Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    onlineTabBarItem.selectedImage = [[UIImage imageNamed:@"Online-Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateNormal];
}

@end
