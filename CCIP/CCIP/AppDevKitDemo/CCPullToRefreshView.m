//
//  CCPullToRefreshView.m
//  CCIP
//
//  Created by Jeff Lin on 8/20/16.
//  Copyright © 2016 CPRTeam. All rights reserved.
//

#import "CCPullToRefreshView.h"
#import <AppDevKit/UIImage+ADKImageFilter.h>
#import <AppDevKit/UIView+ADKAutoLayoutSupport.h>

@interface CCPullToRefreshView ()

@property (nonatomic, weak) UIView *snapView;

@end

@implementation CCPullToRefreshView

#pragma mark - interactive

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupInitConstraint];
}

- (void)setupInitConstraint
{
    CGFloat center = self.center.x;
    CGFloat leftImageWidth = [self.leftAnimationView ADKConstraintForAttribute:NSLayoutAttributeWidth].constant;
    CGFloat rightImageWidth = [self.leftAnimationView ADKConstraintForAttribute:NSLayoutAttributeWidth].constant;
    CGFloat topImageHeight = [self.leftAnimationView ADKConstraintForAttribute:NSLayoutAttributeWidth].constant;
    [self.leftAnimationView ADKSetConstraintConstant:center - leftImageWidth forAttribute:NSLayoutAttributeLeading];
    [self.rightAnimationView ADKSetConstraintConstant:center - rightImageWidth forAttribute:NSLayoutAttributeTrailing];
    [self.topAnimationView ADKSetConstraintConstant:topImageHeight - topImageHeight forAttribute:NSLayoutAttributeTop];
    [self setNeedsLayout];
}

- (void)stopLoadingAnimation
{
    [self.snapView.layer removeAllAnimations];
    self.leftAnimationView.hidden = NO;
    self.rightAnimationView.hidden = NO;
    self.topAnimationView.hidden = NO;
}

#pragma mark - ADKPullToRefreshViewProtocol
- (void)ADKPullToRefreshStopped:(UIScrollView *)scrollView
{
    [self stopLoadingAnimation];
}

- (void)ADKPullToRefreshDragging:(UIScrollView *)scrollView
{
    // NO-OP
}

- (void)ADKPullToRefreshView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress
{
    CGFloat center = self.center.x;
    CGFloat leftImageWidth = [self.leftAnimationView ADKConstraintForAttribute:NSLayoutAttributeWidth].constant;
    CGFloat rightImageWidth = [self.leftAnimationView ADKConstraintForAttribute:NSLayoutAttributeWidth].constant;
    CGFloat topImageHeight = [self.leftAnimationView ADKConstraintForAttribute:NSLayoutAttributeWidth].constant;
    [self.leftAnimationView ADKSetConstraintConstant:center * progress - leftImageWidth forAttribute:NSLayoutAttributeLeading];
    [self.rightAnimationView ADKSetConstraintConstant:center * progress - rightImageWidth forAttribute:NSLayoutAttributeTrailing];
    [self.topAnimationView ADKSetConstraintConstant:topImageHeight * progress - topImageHeight forAttribute:NSLayoutAttributeTop];
    [self setNeedsLayout];
}

- (void)ADKPullToRefreshTriggered:(UIScrollView *)scrollView
{
    // NO-OP
}

- (void)ADKPullToRefreshLoading:(UIScrollView *)scrollView
{
    UIImageView *snapView = [[UIImageView alloc] initWithImage:[UIImage ADKCaptureView:self]];
    [self addSubview:snapView];
    self.snapView = snapView;
    
    self.leftAnimationView.hidden = YES;
    self.rightAnimationView.hidden = YES;
    self.topAnimationView.hidden = YES;
    
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat  animations:^{
        snapView.layer.transform = CATransform3DMakeRotation(M_PI , 0.0f, 1.0f, 0.0f);
    } completion:^(BOOL finished) {
        [snapView removeFromSuperview];
    }];
}

- (CGFloat)ADKPullToRefreshTriggerDistanceTimes:(UIScrollView *)scrollView
{
    return 2.5f;
}

@end
