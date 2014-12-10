//
//  NSDate+Lazy.m
//  r2048
//
//  Created by William Remaerd on 12/10/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "NSDate+Lazy.h"

@implementation NSDate (Lazy)

- (NSUInteger)milliseconds {
    return self.timeIntervalSinceNow * 1000;
}

@end
