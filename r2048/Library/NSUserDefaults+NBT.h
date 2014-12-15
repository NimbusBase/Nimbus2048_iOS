//
//  NSUserDefaults+NBT.h
//  r2048
//
//  Created by William Remaerd on 12/15/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (NBT)

@property (nonatomic, readwrite) BOOL autoSync;

@end

extern NSString
*const UDAutoSync;
