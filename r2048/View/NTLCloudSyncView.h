//
//  NTLFooterIcon.h
//  NimbusTodoList
//
//  Created by William Remaerd on 5/29/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTLCloudSyncView : UIView

@property (nonatomic, assign) BOOL isRotating;

- (void)showSyncView;
- (void)hideSyncView;

@property (nonatomic, weak) UIImageView *syncView;
@property (nonatomic, weak) UIImageView *cloudView;
@property (nonatomic, weak) UIImageView *cloudGapView;

@end
