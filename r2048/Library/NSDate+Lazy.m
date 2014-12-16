//
//  NSDate+Lazy.m
//  r2048
//
//  Created by William Remaerd on 12/10/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "NSDate+Lazy.h"

@implementation NSDate (Lazy)

- (unsigned long long)milliseconds {
    return self.timeIntervalSince1970 * 1000;
}

@end
