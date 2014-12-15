//
//  NMBase+NBT.h
//  r2048
//
//  Created by William Remaerd on 12/15/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBase.h"

@interface NMBase (NBT)

@property (nonatomic, readwrite) BOOL autoSync;
@property (nonatomic, readonly) NSTimer *autoSyncTimer;

- (NMBPromise *)syncDefaultServer;

@end
