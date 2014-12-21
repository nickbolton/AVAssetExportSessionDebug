//
//  NSValue+Bedrock.h
//  Bedrock
//
//  Created by Nick Bolton on 8/8/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (Bedrock)

#if TARGET_OS_IPHONE
+ (NSValue *)valueWithEdgeInsets:(UIEdgeInsets)insets;
- (UIEdgeInsets)edgeInsetsValue;
#else
+ (NSValue *)valueWithEdgeInsets:(NSEdgeInsets)insets;
- (NSEdgeInsets)edgeInsetsValue;
#endif

@end
