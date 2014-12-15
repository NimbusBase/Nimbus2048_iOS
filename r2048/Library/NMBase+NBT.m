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
    [self syncDefaultServer];
}

- (NMBPromise *)syncDefaultServer
{
    NMBServer *server = self.defaultServer;
    if (server != nil && server.isInitialized && !server.isSynchronizing) {
        RTTAppDelegate *appDelegate = APP_DELEGATE;
        if (appDelegate.internetReachability.isReachable) {
            return [server synchronize];
        }
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
