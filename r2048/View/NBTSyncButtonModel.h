//
//  NBTSyncButtonModel.h
//  r2048
//
//  Created by William Remaerd on 12/15/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBTSyncButton, NMBase;

@interface NBTSyncButtonModel : NSObject

@property (nonatomic, strong) NBTSyncButton *button;
@property (nonatomic, strong) NMBase *base;

- (instancetype)initWithSyncButton:(NBTSyncButton *)button base:(NMBase *)base;

@end
