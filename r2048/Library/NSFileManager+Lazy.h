//
//  NSFileManager+Lazy.h
//  r2048
//
//  Created by William Remaerd on 12/10/14.
//  Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Lazy)

+ (NSURL *)applicationDocumentsDirectoryURL;

@end
