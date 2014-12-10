#import "_NBTScore.h"

@interface NBTScore : _NBTScore {}

+ (NSUInteger)deleteAllInMOC:(NSManagedObjectContext *)moc;

+ (instancetype)insertNewBestInMOC:(NSManagedObjectContext *)moc value:(NSNumber *)value;

+ (NSUInteger)deleteAllExceptBestInMOC:(NSManagedObjectContext *)moc;

+ (instancetype)fetchBestInMOC:(NSManagedObjectContext *)moc;

@end