//
//  UIAlertView+Lazy.m
//  r2048
//
//  Created by William Remaerd on 12/11/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "UIAlertView+Lazy.h"

@implementation UIAlertView (Lazy)

+ (UIAlertView *)alertError:(NSError *)error
{
    UIAlertView *alert =
    [[self alloc] initWithTitle:error.domain
                        message:[self messageFromError:error]
                       delegate:nil
              cancelButtonTitle:@"OK"
              otherButtonTitles:nil];
    return alert;
    
}

+ (NSString *)messageFromError:(NSError *)error
{
    NSString
    *description = error.localizedDescription,
    *reason = error.localizedFailureReason,
    *suggestion = error.localizedRecoverySuggestion;
    
    NSMutableString *message = [[NSMutableString alloc] init];
    if (!reason && !suggestion)
        [message appendString:description];
    if (reason)
        [message appendString:reason];
    if (suggestion)
        [message appendString:suggestion];
    
    return message;
}

@end
