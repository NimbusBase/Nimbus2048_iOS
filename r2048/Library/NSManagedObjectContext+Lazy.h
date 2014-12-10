//
//  NSManagedObjectContext+Lazy.h
//  r2048
//
//  Created by William Remaerd on 12/10/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Lazy)

- (NSError *)save;

@end
