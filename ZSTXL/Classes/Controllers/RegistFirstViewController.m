//
//  RegistFirstViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "RegistFirstViewController.h"
#import "RegistSecondViewController.h"

@interface RegistFirstViewController ()

@end

@implementation RegistFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    self.title = @"注册";
    
    self.inviteUserId = @"0";   //不填传0
    self.telLabel.text = self.tel;
    self.scrollView.contentSize = CGSizeMake(320, 320);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.scrollView addGestureRecognizer:tap];
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_nameTextField release];
    [_passwdTextField release];
    [_inviteTextField release];
    [_scrollView release];
    [_telLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setPasswdTextField:nil];
    [self setInviteTextField:nil];
    [self setScrollView:nil];
    [self setTelLabel:nil];
    [super viewDidUnload];
}
- (IBAction)confirm:(UIButton *)sender
{
    [self hideKeyBoard:nil];
    
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
    
    //密码
    if (![self.passwd isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入密码" andImageName:kErrorIcon];
        return;
    } else {
        if ([self.passwd length] < 6) {
            [kAppDelegate showWithCustomAlertViewWithText:@"密码不得小于6位" andImageName:kErrorIcon];
            return;
        }
    }
    
    NSDictionary *para = @{@"path": @"addInvestmentUser.json",
                           @"name": self.name,
                           @"passwd": self.passwd,
                           @"inviteid": self.inviteUserId,
                           @"tel": self.tel,
                           @"uuid": kAppDelegate.uuid,
                           @"allowtel": [NSNumber numberWithInt:self.allowFriendContact]};
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    hud.labelText = @"注册";
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            
            DLog(@"json %@", json);
            
            self.userId = [json objForKey:@"Userid"];
            [self saveUserInfo];
            
            RegistSecondViewController *registSecondVC = [[[RegistSecondViewController alloc] init] autorelease];
            registSecondVC.userid = [json objForKey:@"Userid"];
            [self.navigationController pushViewController:registSecondVC animated:YES];
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

- (void)saveUserInfo
{
    [PersistenceHelper setData:self.userId forKey:kUserId];
    [PersistenceHelper setData:self.name forKey:KUserName];
}

#pragma mark - tap

- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [self.nameTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    [self.inviteTextField resignFirstResponder];
}

#pragma mark - nav bar

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

#pragma mark - textfield delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        self.name = self.nameTextField.text;
        
        
    }else if (textField == self.passwdTextField){
        self.passwd = self.passwdTextField.text;
        
    }else if (textField == self.inviteTextField){
        if (![self.inviteTextField.text isValid]) {
            self.inviteUserId = @"0";
        }
        else{
            self.inviteUserId = self.inviteTextField.text;
        }
    }
}

@end
