//
//  NBTSyncButton.m
//  r2048
//
//  Created by William Remaerd on 12/15/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NBTSyncButton.h"
#import "NTLCloudSyncView.h"
#import <Masonry/Masonry.h>


@implementation NBTSyncButton

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    [self loadSubviewsOnSuperview:self];
}

- (void)loadSubviewsOnSuperview:(UIView *)superview {
    UIView *cloudView = self.cloudView;
    [superview addSubview:cloudView];
    
    [cloudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superview);
        make.size.mas_equalTo(CGSizeMake(31.0f, 31.0f));
    }];
}

- (NTLCloudSyncView *)cloudView {
    if (_cloudView != nil) return _cloudView;
    
    NTLCloudSyncView *cloudView = [[NTLCloudSyncView alloc] init];
    
    return _cloudView = cloudView;
}

@end
