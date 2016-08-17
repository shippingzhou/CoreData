//
//  ContactEditVC.m
//  通讯录
//


#import "ContactEditVC.h"

@interface ContactEditVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;

@end

@implementation ContactEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //赋值默认值
    self.nameTextField.text = self.contact.name;
    self.phoneTextfield.text = self.contact.phoneNum;
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
    
    self.contact.name = self.nameTextField.text;
    self.contact.phoneNum = self.phoneTextfield.text;
    self.contact.namePinYin = [CommonTool getPinYinFromString:self.contact.name];
    self.contact.sectionName = [[self.contact.namePinYin substringToIndex:1] capitalizedString];
    
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
    else if ([ZZRegular regularPhone:self.phoneTextfield.text] == NO)
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
