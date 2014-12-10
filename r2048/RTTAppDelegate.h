//
//  RTTAppDelegate.h
//  r2048
//
//  Created by Viktor Belenyesi on 29/03/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTTMainViewController;

@interface RTTAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

#define APP_DELEGATE ((RTTAppDelegate *)[[UIApplication sharedApplication] delegate])