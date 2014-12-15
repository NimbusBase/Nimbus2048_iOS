//
//  NTLSettingCell.m
//  NimbusTodoList
//
//  Created by William Remaerd on 11/25/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NTLSettingsCell.h"
#import <Masonry/Masonry.h>

#import "UIFont+NBT.h"
#import "UITableViewCell+CCO.h"

@implementation NTLSettingsCell
@synthesize titleLabel = _titleLabel;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:reuseIdentifier])
    {
        [self initialize];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    [self loadConstraints];
}

- (UILabel *)titleLabel {
    if (_titleLabel != nil) return _titleLabel;
    
    UIView *superview = self.contentView;
    UILabel *label = [[UILabel alloc] init];
    
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

+ (UIFont *)textFont {
    return [UIFont defaultFont];
}

#pragma mark - Table View

- (UITableView *)tableView
{
    if (_tableView) return _tableView;
    return _tableView = [self findTableView];
}

@end
