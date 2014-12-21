//
//  UINavigationController+Bedrock.m
//  Bedrock
//
//  Created by Nick Bolton on 11/30/13.
//  Copyright (c) 2013 Pixelbleed. All rights reserved.
//

#import "UINavigationController+Bedrock.h"

@implementation UINavigationController (Bedrock)

+ (UINavigationController *)presentViewController:(UIViewController *)viewController
                               fromViewController:(UIViewController *)presentingViewController
                                       completion:(void(^)(void))completionBlock {
    return
    [self 
     presentViewController:viewController
     fromViewController:presentingViewController
     transitioningDelegate:nil
     completion:completionBlock];
}

+ (UINavigationController *)presentViewController:(UIViewController *)viewController
                               fromViewController:(UIViewController *)presentingViewController
                            transitioningDelegate:(id <UIViewControllerTransitioningDelegate>)transitioningDelegate
                                       completion:(void(^)(void))completionBlock {

    UINavigationController *navigationController =
    [[UINavigationController alloc]
     initWithRootViewController:viewController];

    navigationController.transitioningDelegate = transitioningDelegate;

    [presentingViewController
     presentViewController:navigationController
     animated:YES
     completion:completionBlock];

    return navigationController;
}

- (void)popToViewControllerOfType:(Class)type animated:(BOOL)animated {
    
    UIViewController *viewController = [self viewControllerOfType:type index:NULL];
    
    NSAssert(viewController != nil,
             @"No view controller exists of type %@",
             NSStringFromClass(type));

    [self popToViewController:viewController animated:animated];
}

- (UIViewController *)viewControllerOfType:(Class)type index:(NSUInteger *)indexOut {
    
    __block UIViewController *viewController = nil;
    
    [self.viewControllers
     enumerateObjectsWithOptions:NSEnumerationReverse
     usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         
         if ([obj isKindOfClass:type]) {
             viewController = obj;
             if (indexOut) {
                 *indexOut = idx;
             }
             *stop = YES;
         }
     }];
    
    return viewController;
}

@end
