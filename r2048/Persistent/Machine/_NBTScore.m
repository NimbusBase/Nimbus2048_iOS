// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NBTScore.m instead.

#import "_NBTScore.h"

const struct NBTScoreAttributes NBTScoreAttributes = {
	.createAt = @"createAt",
	.value = @"value",
};

@implementation NBTScoreID
@end

@implementation _NBTScore

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"NBTScore" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"NBTScore";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"NBTScore" inManagedObjectContext:moc_];
}

- (NBTScoreID*)objectID {
	return (NBTScoreID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"createAtValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"createAt"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
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

@dynamic value;

- (int32_t)valueValue {
	NSNumber *result = [self value];
	return [result intValue];
}

- (void)setValueValue:(int32_t)value_ {
	[self setValue:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result intValue];
}

- (void)setPrimitiveValueValue:(int32_t)value_ {
	[self setPrimitiveValue:[NSNumber numberWithInt:value_]];
}

@end

