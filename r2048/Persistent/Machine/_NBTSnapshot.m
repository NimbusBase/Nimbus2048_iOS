// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NBTSnapshot.m instead.

#import "_NBTSnapshot.h"

const struct NBTSnapshotAttributes NBTSnapshotAttributes = {
	.createAt = @"createAt",
	.points = @"points",
	.score = @"score",
	.size = @"size",
	.state = @"state",
};

@implementation NBTSnapshotID
@end

@implementation _NBTSnapshot

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"NBTSnapshot" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"NBTSnapshot";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"NBTSnapshot" inManagedObjectContext:moc_];
}

- (NBTSnapshotID*)objectID {
	return (NBTSnapshotID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"createAtValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"createAt"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"scoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"score"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"size"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"state"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createAt;

- (int64_t)createAtValue {
	NSNumber *result = [self createAt];
	return [result longLongValue];
}

- (void)setCreateAtValue:(int64_t)value_ {
	[self setCreateAt:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveCreateAtValue {
	NSNumber *result = [self primitiveCreateAt];
	return [result longLongValue];
}

- (void)setPrimitiveCreateAtValue:(int64_t)value_ {
	[self setPrimitiveCreateAt:[NSNumber numberWithLongLong:value_]];
}

@dynamic points;

@dynamic score;

- (int32_t)scoreValue {
	NSNumber *result = [self score];
	return [result intValue];
}

- (void)setScoreValue:(int32_t)value_ {
	[self setScore:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveScoreValue {
	NSNumber *result = [self primitiveScore];
	return [result intValue];
}

- (void)setPrimitiveScoreValue:(int32_t)value_ {
	[self setPrimitiveScore:[NSNumber numberWithInt:value_]];
}

@dynamic size;

- (int16_t)sizeValue {
	NSNumber *result = [self size];
	return [result shortValue];
}

- (void)setSizeValue:(int16_t)value_ {
	[self setSize:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSizeValue {
	NSNumber *result = [self primitiveSize];
	return [result shortValue];
}

- (void)setPrimitiveSizeValue:(int16_t)value_ {
	[self setPrimitiveSize:[NSNumber numberWithShort:value_]];
}

@dynamic state;

- (int16_t)stateValue {
	NSNumber *result = [self state];
	return [result shortValue];
}

- (void)setStateValue:(int16_t)value_ {
	[self setState:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStateValue {
	NSNumber *result = [self primitiveState];
	return [result shortValue];
}

- (void)setPrimitiveStateValue:(int16_t)value_ {
	[self setPrimitiveState:[NSNumber numberWithShort:value_]];
}

@end

