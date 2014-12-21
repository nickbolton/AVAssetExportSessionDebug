//
//  PBGradientView.m
//  Bedrock
//
//  Created by Nick Bolton on 11/12/13.
//  Copyright (c) 2013 Pixelbleed. All rights reserved.
//

#import "PBGradientView.h"

@interface PBGradientView()

@property(nonatomic) CGPoint startPoint;
@property(nonatomic) CGPoint endPoint;

@end

@implementation PBGradientView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.vertical = NO;
}

#pragma mark - Getters and Setters

- (void)setVertical:(BOOL)vertical {
    _vertical = vertical;
    self.startPoint = vertical ? CGPointMake(0.5f, 0.0f) : CGPointMake(0.0f, 0.5f);
    self.endPoint   = vertical ? CGPointMake(0.5f, 1.0f) : CGPointMake(1.0f, 0.5f);
    [self setNeedsDisplay];
}

- (void)setStartColor:(UIColor *)startColor {
    _startColor = startColor;
    [self setNeedsDisplay];
}

- (void)setEndColor:(UIColor *)endColor {
    _endColor = endColor;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    NSArray *colors = @[(id)self.startColor.CGColor, (id)self.endColor.CGColor];

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
    
    CGPoint startPoint =
    CGPointMake(self.startPoint.x * CGRectGetWidth(self.bounds),
                self.startPoint.y * CGRectGetHeight(self.bounds));

    CGPoint endPoint =
    CGPointMake(self.endPoint.x * CGRectGetWidth(self.bounds),
                self.endPoint.y * CGRectGetHeight(self.bounds));

    CGContextAddRect(context, self.bounds);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
    [super drawRect:rect];
}

@end
