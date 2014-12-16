//
//  RTTAppDelegate.m
//  r2048
//
//  Created by Viktor Belenyesi on 29/03/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "RTTAppDelegate.h"
#import "RTTMainViewController.h"

#import "NSFileManager+Lazy.h"
#import "NMBase+NBT.h"
#import "NSUserDefaults+NBT.h"
#import "KVOUtilities.h"
#import "NSManagedObjectContext+Lazy.h"

#import <CoreData/CoreData.h>
#import <Reachability/Reachability.h>
#import <NimbusBase/NimbusBase.h>

NSString *const NBTDidMergeCloudChangesNotification = @"NBTDidMergeCloudChangesNotification";

@implementation RTTAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize internetReachability = _internetReachability;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (getenv("RTTUnitTest")) return YES;
    
    _internetReachability = [Reachability reachabilityForInternetConnection];
    
    [self registerObserversWithCenter:[NSNotificationCenter defaultCenter]];
    
    NMBase *base = self.persistentStoreCoordinator.nimbusBase;
    [base loadFromUserDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [RTTMainViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application{
    [self saveContext];
    
    [self unregisterObserversWithCenter:[NSNotificationCenter defaultCenter]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [self.persistentStoreCoordinator.nimbusBase application:application
                                                           openURL:url
                                                 sourceApplication:sourceApplication
                                                        annotation:annotation];
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [coordinator.nimbusBase trackChangesOfMOContext:_managedObjectContext];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Nimbus2048" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel
                                                       nimbusConfigs:self.nimbusBaseConfigs];
    NSNotificationCenter *ntfCntr = [NSNotificationCenter defaultCenter];
    [ntfCntr addObserver:self
                selector:@selector(handlePersistentStoreDidImportUbiquitousContentChangesNotification:)
                    name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                  object:nil];
    
    NSURL *storeURL = [[NSFileManager applicationDocumentsDirectoryURL] URLByAppendingPathComponent:@"Nimbus2048.sqlite"];
    
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        NSLog(@"Unresolved error %@, \n%@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSDictionary *)nimbusBaseConfigs {
    static NSString *const kAppName = @"Nimbus 2048";
    return @{
             NCfgK_Servers: @[
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_GDrive,
                         NCfgK_AppID: @"467471168650-9v08j5mruji6gcskp2ovam903o6g6nsc.apps.googleusercontent.com",
                         NCfgK_AppSecret: @"HgyksCpZ9g7m2wdOJHbB0tOs",
                         },
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_Dropbox,
                         NCfgK_AppID: @"sz3df7p1dr9tq7g",
                         NCfgK_AppSecret: @"rwy8f452n0b16da",
                         },
                     @{
                         NCfgK_AppName: kAppName,
                         NCfgK_Cloud: NCfgV_Box,
                         NCfgK_AppID: @"2xhcxhtuouujye1mjbc70c2h04mmnd9y",
                         NCfgK_AppSecret: @"ae3s2pAFqmYAVcZ8IGOwRvM57Whqd6Zm",
                         },
                     ],
             };
}

- (void)handlePersistentStoreDidImportUbiquitousContentChangesNotification:(NSNotification *)notification {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(handlePersistentStoreDidImportUbiquitousContentChangesNotification:)
                               withObject:notification
                            waitUntilDone:NO];
        return;
    }
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    [moc mergeChangesFromContextDidSaveNotification:notification];
    [moc save];
    
    NSNotificationCenter *ntfCntr = [NSNotificationCenter defaultCenter];
    [ntfCntr postNotificationName:NBTDidMergeCloudChangesNotification object:moc];
}

#pragma mark - User Defaults

- (void)handleUserDefaultsDidChange:(NSNotification *)notification
{
    NSUserDefaults *userDefaults = notification.object;
    NMBase *base = self.persistentStoreCoordinator.nimbusBase;
    base.autoSync = userDefaults.autoSync;
}

#pragma mark - Default server

- (void)handleDefaultServerDidChange:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NMBServer
    *oldServer = userInfo[NSKeyValueChangeOldKey],
    *newServer = userInfo[NSKeyValueChangeNewKey];
    NSNull *null = [NSNull null];
    if ((id)oldServer != null)
        [oldServer removeObserver:self
                       forKeyPath:NMBServerProperties.isInitialized];
    if ((id)newServer != null)
        [newServer addObserver:self
                    forKeyPath:NMBServerProperties.isInitialized
                       options:kvoOptNOI
                       context:nil];
}

- (void)handleDefaultServer:(NMBServer *)server initializedChange:(NSDictionary *)change
{
    BOOL
    wasInit = [change[NSKeyValueChangeOldKey] boolValue],
    isInit = [change[NSKeyValueChangeNewKey] boolValue];
    
    if (!wasInit && isInit) {
        NMBase *base = self.persistentStoreCoordinator.nimbusBase;
        if (base.autoSync) {
            [base syncDefaultServer];
        }
    }
}

#pragma mark - Evnets

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([NMBServerProperties.isInitialized isEqualToString:keyPath]) {
        [self handleDefaultServer:object initializedChange:change];
    }
}

#pragma mark - Global state

- (void)registerObserversWithCenter:(NSNotificationCenter *)center {
    [center addObserver:self
               selector:@selector(handleDefaultServerDidChange:)
                   name:NMBNotiDefaultServerDidChange
                 object:nil];
    [center addObserver:self
               selector:@selector(handleUserDefaultsDidChange:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
}

- (void)unregisterObserversWithCenter:(NSNotificationCenter *)center {
    [center removeObserver:self
                      name:NMBNotiDefaultServerDidChange
                    object:nil];
    [center removeObserver:self
                      name:NSUserDefaultsDidChangeNotification
                    object:nil];
}

@end
