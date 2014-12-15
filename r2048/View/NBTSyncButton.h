//
//  NBTSyncButton.h
//  r2048
//
//  Created by William Remaerd on 12/15/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NTLCloudSyncView;

@interface NBTSyncButton : UIButton

@property (nonatomic, weak) NTLCloudSyncView *cloudView;

@end
