//
// Created by Viktor Belenyesi on 29/03/14.
// Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

@interface NSArray (RTTVectors)

@property (nonatomic, readonly) BOOL containsMove;
- (NSArray *(^)())rotateRight;
- (NSArray *(^)())removeZeroVectors;
- (NSArray *(^)())filterMergePoints;
- (NSArray *(^)())filterCreates;
- (NSArray *(^)())filterMoves;

@end
