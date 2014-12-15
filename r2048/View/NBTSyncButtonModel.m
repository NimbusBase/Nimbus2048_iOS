//
//  NBTSyncButtonModel.m
//  r2048
//
//  Created by William Remaerd on 12/15/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NBTSyncButtonModel.h"
#import <NimbusBase/NimbusBase.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIAlertView+Lazy.h"

#import "NBTSyncButton.h"
#import "NTLCloudSyncView.h"

#import "NMBase+NBT.h"

@implementation NBTSyncButtonModel

- (instancetype)initWithSyncButton:(NBTSyncButton *)button base:(NMBase *)base {
    if (self = [super init]) {
        self.button = button;
        self.base = base;
        
        NSNotificationCenter *ntfCntr = [NSNotificationCenter defaultCenter];
        [ntfCntr addObserver:self
                    selector:@selector(handleDefaultServerDidChangeNotification:)
                        name:NMBNotiDefaultServerDidChange
                      object:base];
        [ntfCntr addObserver:self
                    selector:@selector(handleNMBServerSyncDidFail:)
                        name:NMBNotiSyncDidFail
                      object:nil];
        [ntfCntr addObserver:self
                    selector:@selector(handleNMBServerSyncDidSuccess:)
                        name:NMBNotiSyncDidSucceed
                      object:nil];
        [button addTarget:self
                   action:@selector(handleSyncButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc {
    NSNotificationCenter *ntfCntr = [NSNotificationCenter defaultCenter];
    [ntfCntr removeObserver:self
                       name:NMBNotiDefaultServerDidChange
                     object:self.base];
    [ntfCntr removeObserver:self
                       name:NMBNotiSyncDidFail
                     object:nil];
    [ntfCntr removeObserver:self
                       name:NMBNotiSyncDidSucceed
                     object:nil];

}

- (void)handleDefaultServerDidChangeNotification:(NSNotification *)notification {
    NMBServer *server = notification.userInfo[NSKeyValueChangeNewKey];
    
    NTLCloudSyncView *cloudView = self.button.cloudView;
    
    BOOL canSync = server != nil && server.isInitialized;
    cloudView.alpha = canSync ? 1.0f : 0.5f;
    
    [RACObserve(server, isSynchronizing) subscribeNext:^(NSNumber *syncing) {
        if (syncing.boolValue) {
            [cloudView showSyncView];
            cloudView.isRotating = YES;
        }
        else {
            [cloudView hideSyncView];
            cloudView.isRotating = NO;
        }
    }];
}

- (void)handleNMBServerSyncDidSuccess:(NSNotification *)notification {
}

- (void)handleNMBServerSyncDidFail:(NSNotification *)notification {
    NSError *error = notification.userInfo[NKeyNotiError];
    UIAlertView *alertView = [UIAlertView alertError:error];
    [alertView show];
}

- (void)handleSyncButtonClicked:(UIButton *)button {
    [self.base syncDefaultServer];
}

@end
