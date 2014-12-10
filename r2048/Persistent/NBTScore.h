#import "_NBTScore.h"

@interface NBTScore : _NBTScore {}
// Custom logic goes here.

+ (NSUInteger)deleteAllInMOC:(NSManagedObjectContext *)moc;

+ (instancetype)insertNewBestInMOC:(NSManagedObjectContext *)moc;

+ (NSUInteger)leaveBestOnlyInMOC:(NSManagedObjectContext *)moc;

+ (instancetype)bestInMOC:(NSManagedObjectContext *)moc;

@end

#define APP_DELEGATE ((RTTAppDelegate *)[[UIApplication sharedApplication] delegate])