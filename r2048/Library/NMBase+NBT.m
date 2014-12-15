//
//  NMBase+NBT.m
//  r2048
//
//  Created by William Remaerd on 12/15/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NMBase+NBT.h"
#import <NimbusBase/NimbusBase.h>
#import <Reachability/Reachability.h>
#import "NSUserDefaults+NBT.h"
#import "RTTAppDelegate.h"

@implementation NMBase (NBT)

#pragma mark - Auto Sync

static NSTimer *_autoSyncTimer = nil;

- (void)setAutoSync:(BOOL)autoSync
{
    if (autoSync && _autoSyncTimer == nil) {
        _autoSyncTimer = [NSTimer scheduledTimerWithTimeInterval:60.0f
                                                          target:self
                                                        selector:@selector(handleAutoSyncFired:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    else if (!autoSync && _autoSyncTimer != nil) {
        [_autoSyncTimer invalidate];
        _autoSyncTimer = nil;
    }
}

- (BOOL)autoSync
{
    return _autoSyncTimer != nil && _autoSyncTimer.valid;
}

- (void)handleAutoSyncFired:(NSTimer *)timer
{
    NMBServer *server = self.defaultServer;
    Reachability *reachability = APP_DELEGATE.internetReachability;
    if (server.isInitialized && !server.isSynchronizing && reachability.isReachable) {
        [server synchronize];
    }
}

- (NMBPromise *)syncDefaultServer
{
    if (self.autoSync && self.autoSyncTimer.isValid) {
        [self.autoSyncTimer fire];
    }
    else {
        [self handleAutoSyncFired:nil];
    }
    
    return nil;
}

- (NSTimer *)autoSyncTimer {
    return _autoSyncTimer;
}

#pragma mark -

- (void)loadFromUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Set up auto sync
    
    self.autoSync = defaults.autoSync;
}

@end
