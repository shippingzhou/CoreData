//
//  ContactAddVC.m
//  通讯录
//


#import "ContactAddVC.h"

#import "CoreDataTools.h"

@interface ContactAddVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation ContactAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)leftButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rightButtonClick:(id)sender {
    
    
    if (![self checkTextField]) {
        return;
    }
    //检查数据:电话号码的正则  非空判断
    
    
    Contact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:KZZCoreDataManagedContext.managedObjectContext];
    
    contact.name = self.nameTextField.text;
    contact.phoneNum = self.phoneTextField.text;
    contact.namePinYin = [[CommonTool getPinYinFromString:contact.name] lowercaseString];
    contact.sectionName = [[contact.namePinYin substringToIndex:1] capitalizedString];
    
    [KZZCoreDataManagedContext save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)checkTextField
{
    if(self.nameTextField.text.length == 0)
    {
        UIAlertController *c = [UIAlertController alertControllerWithTitle:@"提示" message:@"姓名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [c addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:c animated:YES completion:nil];
        return NO;
    }
    else if ([ZZRegular regularPhone:self.phoneTextField.text] == NO)
    {
        UIAlertController *c = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号格式错误" preferredStyle:UIAlertControllerStyleAlert];
        [c addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:c animated:YES completion:nil];
        return NO;
    }
    else
        return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
