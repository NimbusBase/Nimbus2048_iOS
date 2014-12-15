//
//  NTLSettingCell.h
//  NimbusTodoList
//
//  Created by William Remaerd on 11/25/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTLSettingsCell : UITableViewCell {
    __weak UILabel *_titleLabel;
}

@property (nonatomic, weak) UILabel *titleLabel;

+ (UIEdgeInsets)cellContentInsets;

@property (nonatomic, weak) UITableView *tableView;

+ (UIFont *)textFont;

@end

#define kNTLSettingsCellHeight 50.0f