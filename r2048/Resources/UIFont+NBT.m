//
//  UIFont+NBT.m
//  r2048
//
//  Created by William Remaerd on 12/12/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "UIFont+NBT.h"

@implementation UIFont (NBT)

+ (UIFont *)defaultFont
{
    static UIFont *font = nil;
    if (font) return font;
    
    return font = [UIFont fontWithName:@"Georgia" size:18.0f];
}

@end
