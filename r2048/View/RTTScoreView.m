//
// Created by Viktor Belenyesi on 30/03/14.
// Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "RTTScoreView.h"
#import "UIColor+RTTFromHex.h"
#import <Masonry/Masonry.h>

@interface RTTScoreView ()

@property (nonatomic, weak) UILabel *scoreLabel;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation RTTScoreView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor fromHex:0xbbada0];
        self.layer.cornerRadius = 3.0f;
        
        UILabel
        *scoreLabel = [self scoreLabel],
        *titleLabel = [self titleLabel];
        titleLabel.text = title;

        UIView
        *superview = self;

        for (UIView *view in @[scoreLabel, titleLabel]) {
            [superview addSubview:view];
        }
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superview);
            make.right.equalTo(superview);
            
            make.top.equalTo(superview).offset(5.0f);
            make.height.mas_equalTo(kButtonHeight * 0.3f);
        }];
        
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superview);
            make.right.equalTo(superview);
            
            make.bottom.equalTo(superview).offset(-5.0f);
            make.height.mas_equalTo(kButtonHeight * 0.7f - 10.0f);
        }];
    }
    return self;
}

- (UILabel *)scoreLabel {
    if (_scoreLabel != nil) return _scoreLabel;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f + kButtonHeight * 0.3f, self.bounds.size.width, kButtonHeight * 0.7f - 10.0f)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    return _scoreLabel = label;
}

- (UILabel *)titleLabel {
    if (_titleLabel != nil) return _titleLabel;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, self.bounds.size.width, kButtonHeight * 0.3f)];
    titleLabel.textColor = [UIColor fromHex:0xeee4da];
    titleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    return _titleLabel = titleLabel;
}

- (void)setScore:(int)score {
    UILabel *scoreLabel = self.scoreLabel;
    int diff = score - _score;
    if (diff > 0 && self.animateChange) {
        UILabel *flyingLabel = [[UILabel alloc] initWithFrame:scoreLabel.frame];
        flyingLabel.textColor = [UIColor fromHex:0x776e65];
        flyingLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        flyingLabel.textAlignment = NSTextAlignmentCenter;
        flyingLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        flyingLabel.text = [NSString stringWithFormat:@"+%d", diff];
        flyingLabel.alpha = 0.0f;
        [self addSubview:flyingLabel];
        
        [UIView animateKeyframesWithDuration:(kScaleAnimDuration + kSlideAnimDuration) * 4.0f
                                       delay:0.0f
                                     options:UIViewKeyframeAnimationOptionCalculationModeCubic
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.1f animations:^{
                                          flyingLabel.alpha = 1.0f;
                                      }];
                                      [UIView addKeyframeWithRelativeStartTime:0.1f relativeDuration:0.4f animations:^{
                                          flyingLabel.frame = CGRectOffset(flyingLabel.frame, 0.0f, -20.0f);
                                      }];
                                      [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.5f animations:^{
                                          flyingLabel.frame = CGRectOffset(flyingLabel.frame, 0.0f, -40.0f);
                                          flyingLabel.alpha = 0.0f;
                                      }];
                                  } completion:^(BOOL finished) {
                                      [flyingLabel removeFromSuperview];
                                  }];
    }
    
    _score = score;
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
}

@end
