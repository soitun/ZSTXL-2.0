//
//  SettingNameViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-28.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingNameViewController.h"
#import "MyInfo.h"
#import "UserDetail.h"

@interface SettingNameViewController ()

@end

@implementation SettingNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"姓名";
    self.view.backgroundColor = bgGreyColor;
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_nameTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNameTextField:nil];
    [super viewDidUnload];
}

- (IBAction)saveName:(UIButton *)sender {
    DLog(@"保存姓名");
    
    [self.nameTextField resignFirstResponder];
    
    //姓名
    if (![self.name isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入用户名" andImageName:kErrorIcon];
        return;
    } else {
        if ([self.name length] < 2)
        {
            [kAppDelegate showWithCustomAlertViewWithText:@"用户名不得少于2个字符" andImageName:kErrorIcon];
            return;
        }
        if (![self.name isMatchedByRegex:@"[\u4e00-\u9fa5]"]) {
            [kAppDelegate showWithCustomAlertViewWithText:@"用户名必须全为汉字" andImageName:kErrorIcon];
            return;
        }
    }
    
    
    NSDictionary *para = @{@"path": @"changeUsername.json",
                           @"username": self.name,
                           @"userid": [PersistenceHelper dataForKey:kUserId]};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            DLog(@"json %@", json);
            [kAppDelegate showWithCustomAlertViewWithText:@"修改成功" andImageName:nil];

            [self saveUserName];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        DLog(@"error %@", error);
    }];
}

- (void)saveUserName
{    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
    MyInfo *myinfo = [MyInfo findFirstWithPredicate:pred];
    myinfo.userDetail.username = self.name;
    DB_SAVE();
}


#pragma mark - nav back button

- (void)initNavBar
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.name = textField.text;
}


@end
