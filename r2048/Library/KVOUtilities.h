//
//  Header.h
//  Uploader
//
//  Created by William Remaerd on 11/15/13.
//  Copyright (c) 2013 William Remaerd. All rights reserved.
//

#ifndef KVOUtilities_h
#define KVOUtilities_h

#define kvo_QuickComparison(cls) \
cls *old = change[NSKeyValueChangeOldKey]; \
cls *new = change[NSKeyValueChangeNewKey]; \
if ([new isEqual:old]) return; \
if ([new isKindOfClass:[NSNull class]]) new = nil;

#define kvoSinglePropertyChangeVariables(cls, noEql) \
cls *oldValue = change[NSKeyValueChangeOldKey], *newValue = change[NSKeyValueChangeNewKey]; \
if ((noEql) && [newValue isEqual:change[NSKeyValueChangeOldKey]]) return; \
if (oldValue == (cls *)[NSNull null]) oldValue = nil; \
if (newValue == (cls *)[NSNull null]) newValue = nil;

#define kvoSinglePropertyChangeNewValue(cls) \
cls *newValue = change[NSKeyValueChangeNewKey]; \
if ([newValue isEqual:change[NSKeyValueChangeOldKey]]) return; \
if (newValue == (cls *)[NSNull null]) newValue = nil;

#define kvoOptNOI (NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)

#endif
