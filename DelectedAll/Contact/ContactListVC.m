//
//  ContactListVC.m
//  通讯录
//


#import "ContactListVC.h"

#import "CoreDataTools.h"

#import "ContactEditVC.h"

@interface ContactListVC ()<NSFetchedResultsControllerDelegate,UISearchBarDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ContactListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSearchBar];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initSearchBar
{
    UISearchBar *bar = [[UISearchBar alloc] init];
    bar.delegate = self;
    self.navigationItem.titleView = bar;
}
- (IBAction)delectedAll:(UIBarButtonItem *)sender {
    
//    KZZCoreDataManagedContext.managedObjectContext = nil;
//    KZZCoreDataManagedContext.managedObjectModel = nil;
//    KZZCoreDataManagedContext.persistentStoreCoordinator = nil;
    
    [KZZCoreDataManagedContext deleteAllEntites];
    
    NSError *error;
    
    [KZZCoreDataManagedContext.persistentStoreCoordinator removePersistentStore:KZZCoreDataManagedContext.persistentStoreCoordinator.persistentStores.firstObject error:&error];
   
    

    
    NSURL *urlPath = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    
    NSURL *url = [urlPath URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",KFileName]];
    [KZZCoreDataManagedContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];

    self.fetchedResultsController = nil;
    
    [self.tableView reloadData];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    searchText = [searchText lowercaseString];
    if (searchText.length > 0) {
        //给fetchedResultsController的查询请求设置查询条件
        self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS %@ || self.phoneNum CONTAINS %@ || self.namePinYin CONTAINS %@ || self.sectionName CONTAINS %@",searchText,searchText,searchText,searchText];
    }
    else
    {
        self.fetchedResultsController.fetchRequest.predicate = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [searchBar resignFirstResponder];
        });
        
    }
    
    
    //执行查询
    [self.fetchedResultsController performFetch:nil];
    
    [self.tableView reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

//懒加载fetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    //创建查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    
    //查询结果设置排序器(一定要设置,否则会崩溃)
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"namePinYin" ascending:YES]];
    /**
     *FetchRequest:查询请求
     * managedObjectContext:管理对象上下文
     * sectionNameKeyPath:分组依据
     * cacheName:缓存 一般为nil
     */
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:KZZCoreDataManagedContext.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    
    //设置代理
    _fetchedResultsController.delegate = self;
    
    //执行查询
    [_fetchedResultsController performFetch:nil];
    
    return _fetchedResultsController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //获取组的数量
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取每一组下面的数组
    id <NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[section];
    return [info numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //获取NSFetchedResultsController中对应的模型对象
    //获取每一组下面的数组
    id <NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[indexPath.section];
    Contact *contact = [info objects][indexPath.row];
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.phoneNum;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //获取NSFetchedResultsController中对应的分组的title
    return self.fetchedResultsController.sectionIndexTitles[section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取对应indexpath的数据模型
    Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //删除数据
    [KZZCoreDataManagedContext.managedObjectContext deleteObject:contact];
    //保存到数据库
    [KZZCoreDataManagedContext save];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return 0;
}


#pragma mark -NSFetchedResultsControllerDelegate
//监听数据库的变化
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ContactEditVC"]) {
        ContactEditVC *edit = (ContactEditVC *)[segue destinationViewController];
        
    
        edit.contact = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}


@end
