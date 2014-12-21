//
//  NSValue+Bedrock.m
//  Prototype
//
//  Created by Nick Bolton on 8/8/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "NSValue+Bedrock.h"

@implementation NSValue (Bedrock)

#if TARGET_OS_IPHONE
+ (NSValue *)valueWithEdgeInsets:(UIEdgeInsets)insets {
    return [NSValue valueWithBytes:&insets objCType:@encode(UIEdgeInsets)];
}

- (UIEdgeInsets)edgeInsetsValue {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    [self getValue:&insets];
    return insets;
}
#else
+ (NSValue *)valueWithEdgeInsets:(NSEdgeInsets)insets {
    return [NSValue valueWithBytes:&insets objCType:@encode(NSEdgeInsets)];
}

- (NSEdgeInsets)edgeInsetsValue {
    NSEdgeInsets insets = NSEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [self getValue:&insets];
    return insets;
}
#endif

@end
