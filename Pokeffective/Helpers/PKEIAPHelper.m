//
//  PKEIAPHelper.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 29/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEIAPHelper.h"
#import "PKEViewControllerHierarchyHelper.h"

NSString * const DidRestoreCompletedTransactionsNotification = @"DidRestoreCompletedTransactionsNotification";

@interface PKEIAPHelper ()

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier;

@end

@implementation PKEIAPHelper

#pragma mark - Public Methods

- (void)getProductsWithIdentifiers:(NSSet *)identifiers
                        completion:(ArrayCompletionBlock)completionBlock
{
    [[CargoBay sharedManager] productsWithIdentifiers:identifiers
                                              success:^(NSArray *products, NSArray *invalidIdentifiers) {
                                                  completionBlock(products, nil);
                                              } failure:^(NSError *error) {
                                                  completionBlock(nil, error);
                                              }];
}
- (void)buyProduct:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)completeTransaction:(SKPaymentTransaction *)paymentTransaction
{
    [self provideContentForProductIdentifier:[[paymentTransaction payment] productIdentifier]];
    [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)paymentTransaction
{
    [self provideContentForProductIdentifier:[[paymentTransaction payment] productIdentifier]];
    [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)paymentTransaction
{
    if ([[paymentTransaction error] code] != SKErrorPaymentCancelled) {
        UIViewController *viewController = [PKEViewControllerHierarchyHelper topViewController];
        [TSMessage showNotificationInViewController:viewController
                                              title:@"Error"
                                           subtitle:@"Something wrong happened, try again later."
                                               type:TSMessageNotificationTypeError
                                           duration:3.0f
                               canBeDismissedByUser:YES];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
}

- (void)restoreCompletedTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - Private Methods

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIViewController *viewController = [PKEViewControllerHierarchyHelper topViewController];
    [TSMessage showNotificationInViewController:viewController
                                          title:@"Success"
                                       subtitle:@"You've unlocked unlimited storage in your box."
                                           type:TSMessageNotificationTypeSuccess
                                       duration:3.0f
                           canBeDismissedByUser:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:DidRestoreCompletedTransactionsNotification
                                                        object:nil
                                                      userInfo:nil];
}

@end
