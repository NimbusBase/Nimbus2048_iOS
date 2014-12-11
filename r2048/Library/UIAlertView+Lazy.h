//
//  UIAlertView+Lazy.h
//  r2048
//
//  Created by William Remaerd on 12/11/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Lazy)

+ (UIAlertView *)alertError:(NSError *)error;
+ (NSString *)messageFromError:(NSError *)error;

@end
