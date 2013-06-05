//
//  LoginViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ForgotPasswdViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageByName:@"login_bg_texture"]];
    self.view.backgroundColor = bgColor;
    
    
    
    self.scrollView.contentSize = CGSizeMake(320, SCREEN_HEIGHT-64);
    [self initNavBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.scrollView addGestureRecognizer:tap];
}

#pragma mark - nav bar

- (void)initNavBar
{
    UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setBackgroundImage:[UIImage imageByName:@"nav_login_button"] forState:UIControlStateNormal];
    [lButton setBackgroundImage:[UIImage imageByName:@"nav_login_button_p"] forState:UIControlStateHighlighted];
    [lButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [lButton setTitle:@"取消" forState:UIControlStateNormal];
    [lButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [lButton addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
    lButton.frame = CGRectMake(0, 0, 54, 32);
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:lButton];
    self.navigationItem.leftBarButtonItem = lBarButton;
}

- (void)cancelLogin
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - tap gesture

- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [self.userIdTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
}

#pragma mark - keyboard

-(void)keyboardWillShow:(NSNotification *)note {
    
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGFloat keyBoardHeight = keyboardBounds.size.height;

    self.scrollView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-keyBoardHeight);
    
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)note {
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.scrollView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_userIdTextField release];
    [_passwdTextField release];
    [_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setUserIdTextField:nil];
    [self setPasswdTextField:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}


#pragma mark - login regist

- (IBAction)login:(UIButton *)sender
{
    DLog(@"login");
    NSString *name = [self.userIdTextField.text removeSpace];
    if (![name isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了"
                                                        message:@"请输入有效的用户名"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSString *pwd = [self.passwdTextField.text removeSpace];
    if (![pwd isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了"
                                                        message:@"请输入有效的密码"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [self.userIdTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"zslogin.json", @"path",
                          name, @"commusername",
                          pwd, @"passwd",
                          kAppDelegate.uuid, @"uuid", nil];
    
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            DLog(@"json %@", json);
            NSString *userId = [[json objForKey:@"Userid"] stringValue];
            
            [PersistenceHelper setData:userId forKey:kUserId];
            [PersistenceHelper setData:pwd forKey:KPassWord];
            [self.navigationController dismissModalViewControllerAnimated:YES];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
    
}

- (IBAction)regist:(UIButton *)sender
{
    DLog(@"regist");
    RegistViewController *registVC = [[[RegistViewController alloc] init] autorelease];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (IBAction)forgetPasswd:(UIButton *)sender
{
    DLog(@"forget passwd");
    [self hideKeyBoard:nil];
    ForgotPasswdViewController *forgotVC = [[[ForgotPasswdViewController alloc] init] autorelease];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

@end
