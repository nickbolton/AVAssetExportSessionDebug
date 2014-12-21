//
//  UINavigationController+Bedrock.h
//  Bedrock
//
//  Created by Nick Bolton on 11/30/13.
//  Copyright (c) 2013 Pixelbleed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Bedrock)

+ (UINavigationController *)presentViewController:(UIViewController *)viewController
                               fromViewController:(UIViewController *)presentingViewController
                                       completion:(void(^)(void))completionBlock;

+ (UINavigationController *)presentViewController:(UIViewController *)viewController
                               fromViewController:(UIViewController *)presentingViewController
                            transitioningDelegate:(id <UIViewControllerTransitioningDelegate>)transitioningDelegate
                                       completion:(void(^)(void))completionBlock;


- (void)popToViewControllerOfType:(Class)type animated:(BOOL)animated;
- (UIViewController *)viewControllerOfType:(Class)type index:(NSUInteger *)indexOut;

@end
