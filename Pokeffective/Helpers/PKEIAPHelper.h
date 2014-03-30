//
//  PKEIAPHelper.h
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 29/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const DidRestoreCompletedTransactionsNotification;

@interface PKEIAPHelper : NSObject

- (void)getProductsWithIdentifiers:(NSSet *)identifiers
                        completion:(ArrayCompletionBlock)completionBlock;
- (void)buyProduct:(SKProduct *)product;
- (void)completeTransaction:(SKPaymentTransaction *)paymentTransaction;
- (void)restoreTransaction:(SKPaymentTransaction *)paymentTransaction;
- (void)failedTransaction:(SKPaymentTransaction *)paymentTransaction;
- (void)restoreCompletedTransactions;

@end
