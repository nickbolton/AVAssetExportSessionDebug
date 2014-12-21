//
//  UIViewController+Bedrock.m
//  Pods
//
//  Created by Nick Bolton on 1/26/14.
//
//

#import "UIViewController+Bedrock.h"

@implementation UIViewController (Bedrock)

- (UINavigationController *)activeNavigationController {

    if (self.navigationController != nil) {
        return self.navigationController;
    }

    return [self.parentViewController activeNavigationController];
}

- (UITabBarController *)activeTabBarController {

    if (self.tabBarController != nil) {
        return self.tabBarController;
    }

    return [self.parentViewController activeTabBarController];
}

@end
