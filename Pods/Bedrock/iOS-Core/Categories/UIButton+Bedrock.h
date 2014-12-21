//
//  UIButton+Bedrock.h
//  Pods
//
//  Created by Nick Bolton on 12/25/13.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (Bedrock)

- (void)bindWiggleAnimationWithView:(UIView *)view
                       withRotation:(CGFloat)rotation
                        translation:(CGPoint)translation
           stopDelayOnTouchUpInside:(NSTimeInterval)stopDelayOnTouchUpInside;

@end
