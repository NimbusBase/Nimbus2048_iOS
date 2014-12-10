// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NBTSnapshot.h instead.

#import <CoreData/CoreData.h>

extern const struct NBTSnapshotAttributes {
	__unsafe_unretained NSString *createAt;
	__unsafe_unretained NSString *points;
	__unsafe_unretained NSString *score;
	__unsafe_unretained NSString *size;
	__unsafe_unretained NSString *state;
} NBTSnapshotAttributes;

@interface NBTSnapshotID : NSManagedObjectID {}
@end

@interface _NBTSnapshot : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NBTSnapshotID* objectID;

@property (nonatomic, strong) NSNumber* createAt;

@property (atomic) int64_t createAtValue;
- (int64_t)createAtValue;
- (void)setCreateAtValue:(int64_t)value_;

//- (BOOL)validateCreateAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* points;

//- (BOOL)validatePoints:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* score;

@property (atomic) int32_t scoreValue;
- (int32_t)scoreValue;
- (void)setScoreValue:(int32_t)value_;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* size;

@property (atomic) int16_t sizeValue;
- (int16_t)sizeValue;
- (void)setSizeValue:(int16_t)value_;

//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* state;

@property (atomic) int16_t stateValue;
- (int16_t)stateValue;
- (void)setStateValue:(int16_t)value_;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@end

@interface _NBTSnapshot (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCreateAt;
- (void)setPrimitiveCreateAt:(NSNumber*)value;

- (int64_t)primitiveCreateAtValue;
- (void)setPrimitiveCreateAtValue:(int64_t)value_;

- (NSString*)primitivePoints;
- (void)setPrimitivePoints:(NSString*)value;

- (NSNumber*)primitiveScore;
- (void)setPrimitiveScore:(NSNumber*)value;

- (int32_t)primitiveScoreValue;
- (void)setPrimitiveScoreValue:(int32_t)value_;

- (NSNumber*)primitiveSize;
- (void)setPrimitiveSize:(NSNumber*)value;

- (int16_t)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int16_t)value_;

- (NSNumber*)primitiveState;
- (void)setPrimitiveState:(NSNumber*)value;

- (int16_t)primitiveStateValue;
- (void)setPrimitiveStateValue:(int16_t)value_;

@end
