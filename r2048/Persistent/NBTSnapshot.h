#import "_NBTSnapshot.h"

@class RTTMatrix;

@interface NBTSnapshot : _NBTSnapshot {}

@property (nonatomic, readonly) RTTMatrix *matrix;

+ (instancetype)insertInMOC:(NSManagedObjectContext *)moc matrix:(RTTMatrix *)matrix score:(NSNumber *)score;

+ (instancetype)fetchLastInMOC:(NSManagedObjectContext *)moc;

+ (NSUInteger)deleteAllInMOC:(NSManagedObjectContext *)moc exceptLast:(NSUInteger)capacity;

@end
