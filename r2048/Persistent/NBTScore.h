#import "_NBTScore.h"

@interface NBTScore : _NBTScore {}

+ (NSUInteger)deleteAllInMOC:(NSManagedObjectContext *)moc;

+ (instancetype)insertNewBestInMOC:(NSManagedObjectContext *)moc value:(NSNumber *)value;

+ (NSUInteger)leaveBestOnlyInMOC:(NSManagedObjectContext *)moc;

+ (instancetype)bestInMOC:(NSManagedObjectContext *)moc;

@end