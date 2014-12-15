//
//  UITableViewCell+CCO.m
//  NimbusTodoList
//
//  Created by William Remaerd on 6/19/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "UITableViewCell+CCO.h"

@implementation UITableViewCell (CCO)

- (UITableView *)findTableView
{
    UIView *view = self.superview;
    
    while (view && [view isKindOfClass:[UITableView class]] == NO)
    {
        view = view.superview;
    }

    return (UITableView *)view;
}

@end
