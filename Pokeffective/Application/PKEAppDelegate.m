//
//  PKEAppDelegate.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 05/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEAppDelegate.h"
#import "PKEPokemonManager.h"

@interface PKEAppDelegate ()

- (void)setupCargoBay;
- (void)setNavigationBarAppearance;
- (void)configureHockeyApp;

@end

@implementation PKEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupCargoBay];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self setNavigationBarAppearance];
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

- (void)setupCargoBay
{
    [[CargoBay sharedManager] setPaymentQueueUpdatedTransactionsBlock:^(SKPaymentQueue *queue, NSArray *transactions) {
        for (SKPaymentTransaction * transaction in transactions) {
            switch (transaction.transactionState) {
                case SKPaymentTransactionStatePurchased:
                    [[PKEPokemonManager sharedManager] completeTransaction:transaction];
                    break;
                case SKPaymentTransactionStateFailed:
                    [[PKEPokemonManager sharedManager] failedTransaction:transaction];
                    break;
                case SKPaymentTransactionStateRestored:
                    [[PKEPokemonManager sharedManager] restoreTransaction:transaction];
                default:
                    break;
            }
        };
    }];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[CargoBay sharedManager]];
}

- (void)configureHockeyApp
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"985be260844cf58133850a264ae0466a"];
    if (!APP_STORE) {
        [[[BITHockeyManager sharedHockeyManager] authenticator] setIdentificationType:BITAuthenticatorIdentificationTypeDevice];
    }
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

@end
