#import "NBTSnapshot.h"
#import "RTTMatrix.h"
#import "NSDate+Lazy.h"

@interface NBTSnapshot ()

// Private interface goes here.

@end

static NSString *const key_maxtrix = @"matrix";

@implementation NBTSnapshot

- (RTTMatrix *)matrix {
    [self willAccessValueForKey:key_maxtrix];
    
    RTTMatrix *matrix = [self primitiveValueForKey:key_maxtrix];
    
    if (matrix == nil) {
        matrix = [[RTTMatrix alloc] initWithString:self.points];
        [self setPrimitiveValue:matrix forKey:key_maxtrix];
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

@end


