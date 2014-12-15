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
static NSString *const kRotateAnimationKey = @"rotationAnimation";

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

- (BOOL)isRotating {
    return [self.syncView.layer animationForKey:kRotateAnimationKey] != nil;
}

- (void)setRotating:(BOOL)rotating {
    CALayer *layer = self.syncView.layer;
    CABasicAnimation *animation = (CABasicAnimation *)[layer animationForKey:kRotateAnimationKey];
    if (rotating && animation == nil) {
        animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.toValue = @( M_PI * 2.0f );
        animation.duration = 1.5f;
        animation.cumulative = YES;
        animation.removedOnCompletion = YES;
        animation.repeatCount = CGFLOAT_MAX;
        
        [layer addAnimation:animation
                     forKey:kRotateAnimationKey];
    }
    else if (!rotating && animation != nil) {
        [layer removeAnimationForKey:kRotateAnimationKey];
    }
}

#pragma mark - Sync

- (void)setArrowsHidden:(BOOL)arrowsHidden {
    self.syncView.alpha = arrowsHidden ? 0.0f : 1.0f;
    self.cloudGapView.alpha = arrowsHidden ? 1.0f : 0.0f;
}

- (void)setArrowsHidden:(BOOL)arrowsHidden animated:(BOOL)animated {
    void (^animation)()  = ^(){
        self.arrowsHidden = arrowsHidden;
    };
    if (animated) {
        [UIView animateWithDuration:kDefaultAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:animation
                         completion:nil];
    }
    else {
        animation();
    }
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
        make.center.equalTo(superview).centerOffset(CGPointMake(0.0f, 5.5f));
    }];
    
    [cloudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
    
    [cloudGapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
}

@end
