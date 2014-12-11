//
//  RTTAppDelegate.m
//  r2048
//
//  Created by Viktor Belenyesi on 29/03/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "RTTAppDelegate.h"
#import "RTTMainViewController.h"
#import <CoreData/CoreData.h>
#import "NSFileManager+Lazy.h"
#import "NimbusBase/NimbusBase.h"

NSString *const NBTDidMergeCloudChangesNotification = @"NBTDidMergeCloudChangesNotification";

@implementation RTTAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (getenv("RTTUnitTest")) return YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [RTTMainViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application{
    [self saveContext];
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

- (NSDictionary *)nimbusBaseConfigs
{
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

- (void)handlePersistentStoreDidImportUbiquitousContentChangesNotification:(NSNotification *)notification
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(handlePersistentStoreDidImportUbiquitousContentChangesNotification:)
                               withObject:notification
                            waitUntilDone:NO];
        return;
    }
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    [moc mergeChangesFromContextDidSaveNotification:notification];
    
    NSNotificationCenter *ntfCntr = [NSNotificationCenter defaultCenter];
    [ntfCntr postNotificationName:NBTDidMergeCloudChangesNotification object:moc];
}

@end
