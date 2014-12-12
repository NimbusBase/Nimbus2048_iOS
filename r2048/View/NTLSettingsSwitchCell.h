//
//  NTLSettingsSwitchCell.h
//  NimbusTodoList
//
//  Created by William Remaerd on 11/25/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NTLSettingsCell.h"

@interface NTLSettingsSwitchCell : NTLSettingsCell

@property (nonatomic, weak) UISwitch *stateSwitch;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
