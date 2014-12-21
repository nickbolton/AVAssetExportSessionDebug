//
//  UIImage+Bedrock.h
//  Bedrock
//
//  Created by Nick Bolton on 12/12/12.
//  Copyright (c) 2012 Pixelbleed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bedrock)

- (UIColor *)colorAtPoint:(CGPoint)point;
- (NSArray *)colorsForStripAtX:(NSUInteger)x;
- (NSArray *)colorsForStripAtY:(NSUInteger)y;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;

- (UIImage *)scaledToSize:(CGSize)size;
- (BOOL)isEqualToImage:(UIImage *)image;
- (NSData *)pngData;

@end
