//
//  NTLSyncCell.h
//  NimbusTodoList
//
//  Created by William Remaerd on 5/1/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NTLSettingsSwitchCell.h"

@class NMBServer;

@interface NTLServerCell : NTLSettingsSwitchCell

@property (nonatomic, strong) NMBServer *server;

@property (nonatomic, weak) UIImageView *cloudIcon;
@property (nonatomic, readonly) UILabel *cloudName;
@property (nonatomic, readonly, strong) UISwitch *authSwitch;

@end