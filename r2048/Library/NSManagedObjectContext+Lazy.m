//
//  NSManagedObjectContext+Lazy.m
//  r2048
//
//  Created by William Remaerd on 12/10/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "NSManagedObjectContext+Lazy.h"

@implementation NSManagedObjectContext (Lazy)

- (NSError *)save{
    NSError *error = nil;
    [self save:&error];
    
    if (error != nil) {
        NSLog(@"NSManagedObjectContext save error: \n%@", error);
    }
    
    return error;
}

@end
