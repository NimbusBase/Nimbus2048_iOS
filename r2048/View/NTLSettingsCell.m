//
//  NTLSettingCell.m
//  NimbusTodoList
//
//  Created by William Remaerd on 11/25/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NTLSettingsCell.h"
#import <Masonry/Masonry.h>

@implementation NTLSettingsCell
@synthesize titleLabel = _titleLabel;

- (void)initialize
{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    //self.contentView.backgroundColor = [UIColor baseCellViewContentColor];
    //self.backgroundColor = [UIColor baseCellViewContentColor];
    
    //[self addSeperatorsOnView:self];
    
    [self loadConstraints];
}

- (UILabel *)titleLabel {
    if (_titleLabel != nil) return _titleLabel;
    
    UIView *superview = self.contentView;
    UILabel *label = [[UILabel alloc] init];
    
    //label.font = [self.class textFont];
    
    [superview addSubview:label];
    
    return _titleLabel = label;
}

- (void)loadConstraints
{
    UIView
    *superview = self.contentView,
    *titleLabel = self.titleLabel;
    UIEdgeInsets
    insets = [self.class cellContentInsets];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).insets(insets);
    }];
}

+ (UIEdgeInsets)cellContentInsets
{
    return UIEdgeInsetsMake(10.0f, 18.0f, 10.0f, 18.0f);
}

@end
