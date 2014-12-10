//
//  NSFileManager+Lazy.m
//  r2048
//
//  Created by William Remaerd on 12/10/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "NSFileManager+Lazy.h"

@implementation NSFileManager (Lazy)

+ (NSURL *)applicationDocumentsDirectoryURL {
    return [[[self defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
