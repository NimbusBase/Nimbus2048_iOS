#import "NBTSnapshot.h"
#import "RTTMatrix.h"
#import "NSDate+Lazy.h"

@interface NBTSnapshot ()

// Private interface goes here.

@end

static NSString *const key_maxtrix = @"matrix";

@implementation NBTSnapshot {
    RTTMatrix *_matrix;
}

- (RTTMatrix *)matrix {
    [self willAccessValueForKey:key_maxtrix];
    
    RTTMatrix *matrix = _matrix;
    
    if (matrix == nil) {
        matrix = [[RTTMatrix alloc] initWithString:self.points];
        _matrix = matrix;
    }
    
    [self didAccessValueForKey:key_maxtrix];
    
    return matrix;
}

+ (instancetype)insertInMOC:(NSManagedObjectContext *)moc matrix:(RTTMatrix *)matrix score:(NSNumber *)score {
    NBTSnapshot *snapshot = [self insertInManagedObjectContext:moc];
    
    snapshot.createAt = @([[NSDate date] milliseconds]);
    snapshot.score = score;
    snapshot.size = @(kMatrixSize);
    snapshot.state = @(matrix.state());
    snapshot.points = matrix.toString;
    
    return snapshot;
}

+ (NSUInteger)deleteAllInMOC:(NSManagedObjectContext *)moc exceptLast:(NSUInteger)capacity {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.includesPropertyValues = NO;
    request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NBTSnapshotAttributes.createAt ascending:NO]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    __block NSUInteger counter = 0;
    [results enumerateObjectsUsingBlock:^(NBTSnapshot *snapshot, NSUInteger idx, BOOL *stop) {
        if (idx < capacity) { return; }
        
        [moc deleteObject:snapshot];
        counter += 1;
    }];
    
    return counter;
}

+ (instancetype)fetchLastInMOC:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NBTSnapshotAttributes.createAt ascending:NO]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    return results.firstObject;
}

+ (NSUInteger)deleteAllInMOC:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.includesPropertyValues = NO;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    for (NSManagedObject * result in results) {
        [moc deleteObject:result];
    }
    
    return results.count;
}


@end


