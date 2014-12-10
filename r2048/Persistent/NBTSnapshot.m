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
    snapshot.state = @(matrix.isOver());
    snapshot.points = matrix.toString;
    
    return snapshot;
}

+ (instancetype)fetchLastInMOC:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NBTSnapshotAttributes.createAt ascending:NO]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    return results.firstObject;
}

@end


