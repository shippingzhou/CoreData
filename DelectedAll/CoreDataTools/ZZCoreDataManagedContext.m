//

#import "ZZCoreDataManagedContext.h"

@implementation ZZCoreDataManagedContext

+ (ZZCoreDataManagedContext *)shareInstance
{
    static ZZCoreDataManagedContext *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZZCoreDataManagedContext alloc] init];
    });
    return manager;
}



//获取沙盒url路径
- (NSURL *)getDocumentsURL
{
    //获取沙盒URL路径
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

//懒加载managedObjectModel
- (NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    //    //创建对象模型   URL:表示的是可视化模型对象的url路径 后缀是momd
    //    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Person" withExtension:@"momd"]];
    
    //合并所有的模型文件 参数表示模型文件的bundle路径  如果为nil  表示自动的合并所有的模型文件
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

//懒加载管理对象的上下文
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    //创建管理对象上下文  参数表示操作数据库线程队列  NSMainQueueConcurrencyType:主线程  保存无延迟  一般使用主线程NSPrivateQueueConcurrencyType:异步线程 保存有延迟
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //设置存储调度器
    [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _managedObjectContext;
}

//懒加载存储调度器persistentStoreCoordinator
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    //创建存储调度器  参数:表示要存储的模型对象
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    //添加一个存储器
    /**
     type:存储类型 一般使用sql类型
     configuration:配置信息  一般无需配置
     options:属性  一般不用设置
     URL:数据库保存的路径
     */
    
    NSURL *url = [[self getDocumentsURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",KFileName]];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    return _persistentStoreCoordinator;
}
// 清空数据库
- (void)deleteAllEntites
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *path1 = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",KFileName]];
    NSString *path2 = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db-shm",KFileName]];
    NSString *path3 = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db-wal",KFileName]];
    
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path1 error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:path2 error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:path3 error:&error];
    
    if (error == nil) {
        NSLog(@"清空数据库成功");
    }
    else
    {
        NSLog(@"清空数据库失败");
        NSLog(@"%@",error.description);
    }
}

- (void)save
{
    [self.managedObjectContext save:nil];
}

@end