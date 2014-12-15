//
//  NTLSettingsSwitchCell.m
//  NimbusTodoList
//
//  Created by William Remaerd on 11/25/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NTLSettingsSwitchCell.h"

#import <Masonry.h>

@implementation NTLSettingsSwitchCell

- (UISwitch *)stateSwitch
{
    if (_stateSwitch != nil) return _stateSwitch;
    
    UIView *superview = self.contentView;
    UISwitch *switsh = [[UISwitch alloc] init];
    //switsh.onTintColor = [UIColor baseCellViewBackgroundColor];
    
    [switsh addTarget:self
               action:@selector(handleStateSwitchValueChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    [superview addSubview:switsh];
    
    return _stateSwitch = switsh;
}

- (void)loadConstraints
{
    UIView
    *superview = self.contentView,
    *switsh = self.stateSwitch,
    *titleLabel = self.titleLabel;
    
    UIEdgeInsets insets = [self.class cellContentInsets];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).insets(insets);
    }];
    
    self.accessoryView = switsh;
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    [self.stateSwitch setOn:on animated:animated];
    self.titleLabel.alpha = on ? 1.0f : 0.4f;
}

#pragma mark - Events

- (void)handleStateSwitchValueChanged:(UISwitch *)stateSwitch
{
    UITableView *tableView = self.tableView;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    if (tableView != nil && indexPath != nil)
        [tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

@end
