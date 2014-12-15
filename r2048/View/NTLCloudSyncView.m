//
//  NTLFooterIcon.m
//  NimbusTodoList
//
//  Created by William Remaerd on 5/29/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NTLCloudSyncView.h"
#import <Masonry/Masonry.h>

#define kDefaultAnimationDuration 0.3f

@implementation NTLCloudSyncView
{
    BOOL _isSyncVisible;
}

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    [self loadSubviewsOnSuperview:self];
}


#pragma mark - Rotate

- (void)setIsRotating:(BOOL)isRotating
{
    if (_isRotating == isRotating) return;
    
    _isRotating = isRotating;
}

- (void)startRotating
{
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = @( M_PI * 2.0f );
    animation.duration = 0.5f;
    animation.cumulative = YES;
    animation.removedOnCompletion = YES;
    
    [self.syncView.layer addAnimation:animation
                               forKey:@"rotationAnimation"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation
                finished:(BOOL)flag
{
    if (self.isRotating)
    {
        [self startRotating];
    }
}

#pragma mark - Sync

- (void)showSyncView
{
    BOOL hideGap = !_isSyncVisible;
    _isSyncVisible = YES;

    if (hideGap)
        [self setCloudGapVisible:NO
                           delay:0.0f];
    
    [self setSyncViewVisible:_isSyncVisible
                       delay:kDefaultAnimationDuration];
    
    if (!self.isRotating)
        [self startRotating];
}

- (void)hideSyncView
{
    BOOL showGap = _isSyncVisible;
    _isSyncVisible = NO;
    
    [self setSyncViewVisible:_isSyncVisible
                       delay:0.0f];
    
    if (showGap)
        [self setCloudGapVisible:YES
                           delay:kDefaultAnimationDuration];
}

- (void)setCloudGapVisible:(BOOL)isVisible
                     delay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:kDefaultAnimationDuration
                          delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:
     ^{
         self.cloudGapView.alpha = isVisible ? 1.0f : 0.0f;
     }
                              completion:nil];
}

- (void)setSyncViewVisible:(BOOL)visible
                     delay:(NSTimeInterval)delay
{
    [UIView animateKeyframesWithDuration:kDefaultAnimationDuration
                                   delay:0.0f
                                 options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                              animations:
     ^{
         self.syncView.alpha = visible ? 1.0f : 0.0f;
     }
                              completion:nil];
}

#pragma mark - Subviews

- (UIImageView *)syncView
{
    if (_syncView) return _syncView;
    
    UIImageView *sync = [[UIImageView alloc] init];
    sync.image = [UIImage imageNamed:@"cloud_black_sync"];
    
    return _syncView = sync;
}

- (UIImageView *)cloudView
{
    if (_cloudView) return _cloudView;
    
    UIImageView *cloud = [[UIImageView alloc] init];

    cloud.image = [UIImage imageNamed:@"cloud_black"];
    
    return _cloudView = cloud;
}

- (UIImageView *)cloudGapView
{
    if (_cloudGapView) return _cloudGapView;
    
    UIImageView *gap = [[UIImageView alloc] init];
    gap.image = [UIImage imageNamed:@"cloud_black_gap"];
    
    return _cloudGapView = gap;
}

- (void)loadSubviewsOnSuperview:(UIView *)superview {
    UIView
    *syncView = self.syncView,
    *cloudView = self.cloudView,
    *cloudGapView = self.cloudGapView;
    
    for (UIView *view in @[syncView, cloudView, cloudGapView]) {
        [superview addSubview:view];
    }
    
    CGFloat size = 13.0f;
    [syncView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size, size));
        make.center.equalTo(superview).sizeOffset(CGSizeMake(0.0f, 5.5f));
    }];
    
    [cloudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
    
    [cloudGapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
}

@end
