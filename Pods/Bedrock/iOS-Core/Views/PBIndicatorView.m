//
//  PBIndicatorView.m
//  Bedrock
//
//  Created by Nick Bolton on 5/26/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "PBIndicatorView.h"
#import "PBRunningAverageValue.h"

static CGFloat const kPBIndicatorViewShowIndicatorScrollVelocityThreshold = 1.4f;
static CGFloat const kPBIndicatorViewHideIndicatorScrollVelocityStartThreshold = 300.0f;

@interface PBIndicatorView()

@property (nonatomic, strong) UIView *indicatorBackgroundView;
@property (nonatomic, strong) UILabel *indicatorLabel;
@property (nonatomic) PBIndicatorState indicatorState;
@property (nonatomic) NSTimeInterval lastScrollTime;
@property (nonatomic) NSTimeInterval indicatorStopTime;
@property (nonatomic) NSTimeInterval lastIndicatorTrigger;
@property (nonatomic, getter = isDecelerating) BOOL decelerating;
@property (nonatomic) CGFloat lastScrollPosition;
@property (nonatomic, strong) PBRunningAverageValue *averageScrollSpeed;
@property (nonatomic) UIEdgeInsets labelInsets;

@end

@implementation PBIndicatorView

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

- (instancetype)initWithBackgroundAlpha:(CGFloat)alpha {
    return [self initWithBackgroundAlpha:alpha labelInsets:UIEdgeInsetsZero];
}

- (instancetype)initWithBackgroundAlpha:(CGFloat)alpha
                            labelInsets:(UIEdgeInsets)labelInsets {
    self = [super init];
    if (self) {
        self.labelInsets = labelInsets;
        self.backgroundAlpha = alpha;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    self.alpha = 0.0f;
    self.indicatorState = PBIndicatorStateHidden;

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.backgroundColor = self.tintColor;
    backgroundView.alpha = self.backgroundAlpha;
    
    self.indicatorBackgroundView = backgroundView;
    
    [self addSubview:backgroundView];
    [NSLayoutConstraint expandToSuperview:backgroundView];
    
    self.indicatorLabel = [[UILabel alloc] init];
    self.indicatorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorLabel.textAlignment = NSTextAlignmentCenter;
    self.indicatorLabel.font =
    [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f];
    
    CGFloat statusBarHeight =
    CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    
    [self addSubview:self.indicatorLabel];
    [NSLayoutConstraint expandWidthToSuperview:self.indicatorLabel withInsets:self.labelInsets];
    [NSLayoutConstraint alignToTop:self.indicatorLabel withPadding:statusBarHeight+self.labelInsets.top];
    [NSLayoutConstraint alignToBottom:self.indicatorLabel withPadding:self.labelInsets.bottom];
    
    self.averageScrollSpeed = [[PBRunningAverageValue alloc] init];
}

#pragma mark - Getters and Setters

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha {
    _backgroundAlpha = backgroundAlpha;
    self.indicatorBackgroundView.alpha = backgroundAlpha;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.indicatorLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.indicatorLabel.textColor = textColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.indicatorBackgroundView.backgroundColor = tintColor;
}

#pragma mark - Public


- (BOOL)willMonthIndicatorBeVisible {
    return
    self.indicatorState == PBIndicatorStateShowing ||
    self.indicatorState == PBIndicatorStateVisible;
}

- (BOOL)willMonthIndicatorBeHidden {
    return
    self.indicatorState == PBIndicatorStateHiding ||
    self.indicatorState == PBIndicatorStateHidden;
}

- (void)showMonthIndicatorContainer {
    
    self.alpha = 0.0f;
    self.indicatorState = PBIndicatorStateShowing;
    
    [UIView
     animateWithDuration:.3f
     animations:^{
         self.alpha = 1.0f;
         self.navigationController.navigationBar.alpha = 0.0f;
     } completion:^(BOOL finished) {
         self.indicatorState = PBIndicatorStateVisible;
     }];
}

- (void)hideMonthIndicatorContainer {
    
    self.indicatorState = PBIndicatorStateHiding;
    
    [UIView
     animateWithDuration:.3f
     animations:^{
         self.alpha = 0.0f;
         self.navigationController.navigationBar.alpha = 1.0f;
     } completion:^(BOOL finished) {
         self.indicatorState = PBIndicatorStateHidden;
     }];
}

- (void)ensureMonthIndicatorHides {
    
    if ([self willMonthIndicatorBeVisible] && self.isAutoScrolling == NO) {
        
        static CGFloat const epsilon = .0001f;
        static CGFloat const threshold = .3f;
        
        __weak typeof(self) this = self;
        
        NSTimeInterval delayInSeconds = threshold;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            
            NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval timeDelta = now - self.lastScrollTime;
            
            if (timeDelta > (threshold-epsilon)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [this hideMonthIndicatorContainer];
                });
            }
        });
    }
}

#pragma mark - UIScrollViewDelegate Conformance

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    NSTimeInterval beginDraggingTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval delayInSeconds = .3f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if (self.lastIndicatorTrigger < beginDraggingTime) {
            [self hideMonthIndicatorContainer];
        }
    });
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    self.decelerating = decelerate;

    if (decelerate) {
        
        self.lastScrollPosition = scrollView.contentOffset.y;
        self.lastScrollTime = [NSDate timeIntervalSinceReferenceDate];
        [self.averageScrollSpeed clearRunningValues];

    } else {
        
        [self hideMonthIndicatorContainer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.decelerating = NO;
    [self hideMonthIndicatorContainer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if ([self willMonthIndicatorBeHidden] &&
        ABS(velocity.y) > kPBIndicatorViewShowIndicatorScrollVelocityThreshold) {
        
        [self showMonthIndicatorContainer];
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal * 2.0f;
        
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        
        self.lastIndicatorTrigger = now;
        self.indicatorStopTime = (3.0f * .8f) + now;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        
    if (self.isDecelerating) {
        
        CGFloat scrollPosition = scrollView.contentOffset.y;
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        
        NSTimeInterval deltaT = now - _lastScrollTime;
        CGFloat deltaY = scrollPosition - _lastScrollPosition;
        CGFloat speed = ABS(deltaY / deltaT);
        
        if (speed < 50000.0f ) {
            
            self.averageScrollSpeed.value = speed;
        }
        
        if (now >= self.indicatorStopTime &&
            self.averageScrollSpeed.value < kPBIndicatorViewHideIndicatorScrollVelocityStartThreshold) {
            [self hideMonthIndicatorContainer];
        } else {
            self.lastIndicatorTrigger = now;
        }
        
        _lastScrollPosition = scrollPosition;
        _lastScrollTime = now;
    }
    
    [self ensureMonthIndicatorHides];
}

@end
