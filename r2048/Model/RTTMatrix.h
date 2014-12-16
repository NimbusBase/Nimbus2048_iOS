//
// Created by Viktor Belenyesi on 29/03/14.
// Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

@class RTTPoint;
@class RTTTile;

typedef NS_ENUM(NSInteger, RTTMatrixState) {
    RTTMatrixStateLost = -1,
    RTTMatrixStateNormal = 0,
    RTTMatrixStateWin = 1,
};

@interface RTTMatrix : NSObject

RTTMatrix* emptyMatrix();

- (int(^)(RTTPoint*))valueAt;

- (NSArray*(^)( NSNumber*))mapDirectionToReduceVectors;
- (NSArray*(^)())getEmptyPositions;
- (NSArray*(^)())getTiles;
- (NSArray*(^)())getNonZeroTitles;
- (RTTTile*(^)())getNewRandomTile;

- (BOOL(^)())isOver;
- (BOOL(^)())isWin;
- (RTTMatrixState(^)())state;

- (RTTMatrix*(^)(RTTPoint*, int))addValue;
- (RTTMatrix*(^)(RTTPoint*, int))subtractValue;
- (RTTMatrix*(^)(NSArray*))applyReduceCommands;
- (RTTMatrix*(^)())rotateRight;
- (RTTMatrix*(^)())transpose;
- (RTTMatrix*(^)())reverseRowWise;

- (NSString *)toString;
- (instancetype)initWithString:(NSString *)string;

@end
