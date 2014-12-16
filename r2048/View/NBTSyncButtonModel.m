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
        
        NMBServer *server = base.defaultServer;
        
        button.enabled = [self.class buttonEnableWithServer:server
                                                initialized:server.isInitialized
                                                    syncing:server.isSynchronizing];
        
        NTLCloudSyncView *cloudView = button.cloudView;
        BOOL syncing = server != nil && server.isSynchronizing;
        cloudView.alpha = [self.class cloudViewAlphaWithServer:server initialized:server.isInitialized];
        cloudView.arrowsHidden = !syncing;
        cloudView.rotating = syncing;
        
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
    id null = [NSNull null];
    
    NBTSyncButton *button = self.button;
    NTLCloudSyncView *cloudView = button.cloudView;
    
    if (null != server) {
        button.enabled = [self.class buttonEnableWithServer:server
                                                initialized:server.isInitialized
                                                    syncing:server.isSynchronizing];
        cloudView.alpha = [self.class cloudViewAlphaWithServer:server
                                                   initialized:server.isInitialized];
        [[RACObserve(server, isSynchronizing) deliverOn:RACScheduler.mainThreadScheduler]
         subscribeNext:^(NSNumber *syncingValue) {
            BOOL syncing = syncingValue.boolValue;
            [cloudView setArrowsHidden:!syncing animated:YES];
            cloudView.rotating = syncing;
            
            button.enabled = [self.class buttonEnableWithServer:server
                                                    initialized:server.isInitialized
                                                        syncing:syncing];
        }];
        [[RACObserve(server, isInitialized) deliverOn:RACScheduler.mainThreadScheduler]
         subscribeNext:^(NSNumber *initializedValue) {
            BOOL initialized = initializedValue.boolValue;
            button.enabled = [self.class buttonEnableWithServer:server
                                                    initialized:initialized
                                                        syncing:server.isSynchronizing];
        }];
        
    }
    else {
        button.enabled = [self.class buttonEnableWithServer:nil
                                                initialized:NO
                                                    syncing:NO];
        cloudView.alpha = [self.class cloudViewAlphaWithServer:nil
                                                   initialized:NO];
    }
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

+ (CGFloat)cloudViewAlphaWithServer:(NMBServer *)server initialized:(BOOL)initialized {
    BOOL canSync = server != nil && initialized;
    return canSync ? 1.0f : 0.5f;
}

+ (BOOL)buttonEnableWithServer:(NMBServer *)server initialized:(BOOL)initialized syncing:(BOOL)syncing {
    return server != nil && initialized && !syncing;
}

@end
