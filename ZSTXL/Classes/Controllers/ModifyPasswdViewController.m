//
//  ModifyPasswdViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-5.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ModifyPasswdViewController.h"

@interface ModifyPasswdViewController ()

@end

@implementation ModifyPasswdViewController

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
    self.title = @"修改密码";

    [self initScrollView];
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_scrollView release];
    [_oldPasswdTextField release];
    [_theNewPasswdTextField release];
    [_renewPasswdTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setOldPasswdTextField:nil];
    [self setTheNewPasswdTextField:nil];
    [self setRenewPasswdTextField:nil];
    [super viewDidUnload];
}

- (IBAction)saveAction:(UIButton *)sender
{
    [self hideKeyboard];
    
    if (![self.oldPasswd isEqualToString:[PersistenceHelper dataForKey:KPassWord]]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"旧密码不匹配" andImageName:kErrorIcon];
        return;
    }
    
    if (![self.theNewPasswd isEqualToString:self.renewPasswd]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"确认密码和新密码不同" andImageName:kErrorIcon];
        return;
    }
    
    if ([[self.theNewPasswd removeSpace] length] < 6) {
        [kAppDelegate showWithCustomAlertViewWithText:@"新密码必须大于6位" andImageName:kErrorIcon];
        return;
    }
    
    NSDictionary *para = @{@"path": @"changeZsUserPassword.json",
                           @"oldpasswd": self.oldPasswd,
                           @"newpasswd": self.theNewPasswd,
                           @"userid": [PersistenceHelper dataForKey:kUserId]};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            [kAppDelegate showWithCustomAlertViewWithText:@"修改成功" andImageName:nil];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        DLog(@"err %@", error);
    }];
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

#pragma mark - scroll view

- (void)initScrollView
{
    self.scrollView.contentSize = CGSizeMake(320, 360);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:tap];
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

- (void)hideKeyboard
{
    [self.oldPasswdTextField resignFirstResponder];
    [self.theNewPasswdTextField resignFirstResponder];
    [self.renewPasswdTextField resignFirstResponder];
}

#pragma mark - textfield delegate 

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.oldPasswdTextField) {
        self.oldPasswd = self.oldPasswdTextField.text;
    }else if(textField == self.theNewPasswdTextField){
        self.theNewPasswd = self.theNewPasswdTextField.text;
    }else{
        self.renewPasswd = self.renewPasswdTextField.text;
    }
}
@end
