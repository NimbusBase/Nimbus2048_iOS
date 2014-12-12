//
//  NTLSyncCell.m
//  NimbusTodoList
//
//  Created by William Remaerd on 5/1/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NTLServerCell.h"
#import "NTLSettingsCell.h"

#import "NimbusBase/NimbusBase.h"
#import <Masonry.h>

#import "KVOUtilities.h"

@interface NTLServerCell ()

@property (nonatomic, readwrite, strong) UISwitch *authSwitch;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation NTLServerCell

- (void)dealloc
{
    self.server = nil;
}

- (void)setServer:(NMBServer *)server
{
    if (_server == server) return;
    
    if (_server)
    {
        [_server removeObserver:self
                     forKeyPath:NMBServerProperties.authState];
        [_server removeObserver:self
                     forKeyPath:NMBServerProperties.isInitialized];
    }
    
    _server = server;

    if (server)
    {
        [server addObserver:self
                  forKeyPath:NMBServerProperties.authState
                     options:kvoOptNOI
                     context:nil];
        [server addObserver:self
                  forKeyPath:NMBServerProperties.isInitialized
                     options:kvoOptNOI
                     context:nil];
        
        self.cloudIcon.image = [UIImage imageNamed:server.iconName];
        self.cloudName.text = server.cloudType;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.server)
    {
        NMBServer *server = object;
        if ([NMBServerProperties.authState isEqualToString:keyPath])
        {
            kvoSinglePropertyChangeNewValue(NSNumber);
            [self configWithServer:server authState:newValue.integerValue initialized:server.isInitialized];
        }
        else if ([NMBServerProperties.isInitialized isEqualToString:keyPath]) {
            kvoSinglePropertyChangeNewValue(NSNumber);
            [self configWithServer:server authState:server.authState initialized:newValue.boolValue];
        }
    }
}

+ (UIFont *)textFont
{
    UIFont *superFont = [super textFont];
    return [UIFont fontWithName:superFont.fontName
                           size:superFont.pointSize + 2.0f];
}

#pragma mark - Subviews

- (UIImageView *)cloudIcon
{
    if (_cloudIcon) return _cloudIcon;
    
    UIView *superview = self.contentView;
    UIImageView *icon = [[UIImageView alloc] init];
    
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:icon];

    return _cloudIcon = icon;
}

- (UILabel *)cloudName
{
    if (_titleLabel != nil) return _titleLabel;
    
    UIView *superview = self.contentView;
    UILabel *label = [[UILabel alloc] init];
    
    label.font = [self.class textFont];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:label];

    return _titleLabel = label;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator != nil) return _activityIndicator;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    
    return _activityIndicator = indicator;
}

- (UISwitch *)authSwitch
{
    if (_authSwitch != nil) return _authSwitch;
    
    UISwitch *authSwitch = [super stateSwitch];
    [authSwitch removeFromSuperview];
    
    return _authSwitch = authSwitch;
}

- (void)loadConstraints
{
    UIView
    *superview = self.contentView,
    *cloudIcon = self.cloudIcon,
    *cloudName = self.cloudName;
    
    UIEdgeInsets insets = [self.class cellContentInsets];
    CGSize iconSize = [self.class iconSize];
    
    [cloudIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(iconSize);
        make.left.equalTo(superview).offset(insets.left);
        make.right.equalTo(cloudName).offset(10.0f);
        make.centerY.equalTo(cloudName);
    }];
    
    [cloudName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(insets.right);
        make.centerY.equalTo(cloudName);
        make.height.mas_equalTo(kNTLSettingsCellHeight - insets.top - insets.bottom);
    }];
}

- (void)configWithServer:(NMBServer *)server
               authState:(NMBAuthState)authState
             initialized:(BOOL)initialized
{
    BOOL active =
    NMBAuthStateSignIn == authState ||
    NMBAuthStateSignOut == authState ||
    (NMBAuthStateIn == authState && !initialized);
    
    UIActivityIndicatorView *indicator = self.activityIndicator;
    UISwitch *authSwitch = self.authSwitch;
    if (active) {
        [indicator startAnimating];
        self.accessoryView = indicator;
    }
    else {
        [indicator stopAnimating];
        [authSwitch setOn:(NMBAuthStateIn == authState) animated:YES];
        self.accessoryView = authSwitch;
    }
    
    self.cloudIcon.alpha = self.cloudName.alpha = initialized ? 1.0f : 0.4f;
}

#pragma mark - Values

+ (CGSize)iconSize
{
    return CGSizeMake(45.0f, 25.0f);
}

@end
