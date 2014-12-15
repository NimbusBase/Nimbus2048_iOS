//
//  NSUserDefaults+NBT.m
//  r2048
//
//  Created by William Remaerd on 12/15/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "NSUserDefaults+NBT.h"

@implementation NSUserDefaults (NBT)

- (BOOL)autoSync
{
    NSNumber *autoSync = [self objectForKey:UDAutoSync];
    return autoSync == nil ? NO : autoSync.boolValue;
}

- (void)setAutoSync:(BOOL)autoSync
{
    [self setObject:@(autoSync)
             forKey:UDAutoSync];
}

@end

NSString
*const UDAutoSync = @"com.nimbusbase.todolist.ud.autoSync";