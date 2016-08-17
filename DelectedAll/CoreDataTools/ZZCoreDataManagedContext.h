//


#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#define KZZCoreDataManagedContext [ZZCoreDataManagedContext shareInstance]

#define KFileName @"mysql"

@interface ZZCoreDataManagedContext : NSObject

+ (ZZCoreDataManagedContext *)shareInstance;

-(void)deleteAllEntites;

//管理对象的上下文
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;

//模型对象
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

//存储调度器
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//保存到数据库
- (void)save;

@end