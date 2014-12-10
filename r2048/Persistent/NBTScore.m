#import "NBTScore.h"
#import "NSDate+Lazy.h"

@interface NBTScore ()

// Private interface goes here.

@end

@implementation NBTScore

+ (NSUInteger)deleteAllInMOC:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.includesPendingChanges = NO;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];

    for (NSManagedObject * result in results) {
        [moc deleteObject:result];
    }
    
    return results.count;
}

+ (instancetype)insertNewBestInMOC:(NSManagedObjectContext *)moc value:(NSNumber *)value {
    NBTScore *score = [NBTScore insertInManagedObjectContext:moc];
    score.createAt = @([[NSDate date] milliseconds]);
    score.value = value;
    return score;
}

+ (NSUInteger)deleteAllExceptBestInMOC:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NBTScoreAttributes.value ascending:NO]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    __block NSUInteger counter = 0;
    [results enumerateObjectsUsingBlock:^(NBTScore *score, NSUInteger idx, BOOL *stop) {
        if (idx < 1) { return; }
        
        [moc deleteObject:score];
        counter += 1;
    }];
    
    return counter;
}

+ (instancetype)fetchBestInMOC:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NBTScoreAttributes.value ascending:NO]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    return results.firstObject;
}

@end
