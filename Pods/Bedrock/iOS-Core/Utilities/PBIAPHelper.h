//
//  PBIAPHelper.h
//  Bedrock
//
//  Created by Nick Bolton on 1/12/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

@interface PBIAPHelper : NSObject

@property (nonatomic, readonly) NSArray *products;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(void (^)(BOOL success, NSArray * products))completionHandler;
- (void)buyProductWithIdentifier:(NSString *)productIdentifier
        completion:(void(^)(BOOL success, NSError *error))completionHandler;
- (void)buyProduct:(SKProduct *)product
        completion:(void(^)(BOOL success, NSError *error))completionHandler;

- (SKProduct *)productWithIdentifier:(NSString *)productIdentifier;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;

@end
