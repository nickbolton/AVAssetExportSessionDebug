//
//  PBIndicatorView.h
//  Bedrock
//
//  Created by Nick Bolton on 5/26/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PBIndicatorState) {
    
    PBIndicatorStateHidden = 0,
    PBIndicatorStateShowing,
    PBIndicatorStateHiding,
    PBIndicatorStateVisible,
};

@interface PBIndicatorView : UIView <UIScrollViewDelegate>

- (instancetype)initWithBackgroundAlpha:(CGFloat)alpha;
- (instancetype)initWithBackgroundAlpha:(CGFloat)alpha
                            labelInsets:(UIEdgeInsets)labelInsets;

@property (nonatomic) CGFloat backgroundAlpha;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, getter = isAutoScrolling) BOOL autoScrolling;
@property (nonatomic, weak) UINavigationController *navigationController;

- (BOOL)willMonthIndicatorBeVisible;
- (BOOL)willMonthIndicatorBeHidden;
- (void)showMonthIndicatorContainer;
- (void)hideMonthIndicatorContainer;
- (void)ensureMonthIndicatorHides;

@end
