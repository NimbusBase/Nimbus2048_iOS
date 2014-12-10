// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NBTScore.h instead.

#import <CoreData/CoreData.h>

extern const struct NBTScoreAttributes {
	__unsafe_unretained NSString *createAt;
	__unsafe_unretained NSString *value;
} NBTScoreAttributes;

@interface NBTScoreID : NSManagedObjectID {}
@end

@interface _NBTScore : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NBTScoreID* objectID;

@property (nonatomic, strong) NSNumber* createAt;

@property (atomic) int64_t createAtValue;
- (int64_t)createAtValue;
- (void)setCreateAtValue:(int64_t)value_;

//- (BOOL)validateCreateAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* value;

@property (atomic) int32_t valueValue;
- (int32_t)valueValue;
- (void)setValueValue:(int32_t)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;

@end

@interface _NBTScore (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCreateAt;
- (void)setPrimitiveCreateAt:(NSNumber*)value;

- (int64_t)primitiveCreateAtValue;
- (void)setPrimitiveCreateAtValue:(int64_t)value_;

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int32_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int32_t)value_;

@end
