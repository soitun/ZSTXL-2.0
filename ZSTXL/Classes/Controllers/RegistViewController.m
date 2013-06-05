//
//  RegistViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistFirstViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"注册";
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
    self.scrollView.contentSize = CGSizeMake(320, SCREEN_HEIGHT-64);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.scrollView addGestureRecognizer:tap];
    
    self.allowFriendContact = 1;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allowFriendContact:)];
    [self.friendContactImage addGestureRecognizer:tapImage];
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

    
    [_telTextField release];
    [_authCodeTextField release];
    [_scrollView release];
    [_countDownLabel release];
    [_friendContactImage release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTelTextField:nil];
    [self setAuthCodeTextField:nil];
    [self setScrollView:nil];
    [self setCountDownLabel:nil];
    [self setFriendContactImage:nil];
    [super viewDidUnload];
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
    [self stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tap

- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [self.authCodeTextField resignFirstResponder];
    [self.telTextField resignFirstResponder];
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
    self.scrollView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-keyBoardHeight+20);
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

- (IBAction)getAuthCode:(UIButton *)sender
{
    DLog(@"getAuthcode");
    
    [self hideKeyBoard:nil];
    
    [self.telTextField resignFirstResponder];
    if (![Utility mobileNumIsValid:self.tel]) {
        return;
    }else{
        
        if (self.countDownTimer != nil) {
            [Utility showAlertWithTitle:@"三分钟内请勿重复获取"];
            return;
        }
        
        
        NSDictionary *para = @{@"path": @"sendCheckingCode.json", @"phoneNm": self.tel, @"type" : @"2"};
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
        hud.labelText = @"获取验证码";
        [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            
            if (RETURNCODE_ISVALID(json)) {
                self.lastAuthCodeDate = [NSDate date];
                self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                DLog(@"json %@", json);
            }
            else{
                DLog(@"%@", GET_RETURNMESSAGE(json));
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
            DLog(@"error %@", error);
        }];
    }
}

- (void)allowFriendContact:(UITapGestureRecognizer *)tap
{
    DLog(@"allowFriendContact");
    self.allowFriendContact = 1 - self.allowFriendContact;
    if (self.allowFriendContact == 0) {
        self.friendContactImage.image = [UIImage imageNamed:@"login_select"];
    }
    else{
        self.friendContactImage.image = [UIImage imageNamed:@"login_noselect"];
    }
}

- (IBAction)regist:(UIButton *)sender
{
    
    [self hideKeyBoard:nil];
    //验证验证码
    DLog(@"regist");
    if (![self.authCode isValid]) {
        [Utility showAlertWithTitle:@"请输入验证码"];
        return;
    }
    else{
        NSDictionary *para = @{@"path": @"checkingCode.json", @"phoneNm": self.tel, @"verificationCode": self.authCode};
        [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
        [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            if (RETURNCODE_ISVALID(json)) {
                
                [self stopTimer];
                
                RegistFirstViewController *registFirstVC = [[[RegistFirstViewController alloc] init] autorelease];
                registFirstVC.tel = self.tel;
                registFirstVC.allowFriendContact = self.allowFriendContact;
                [self.navigationController pushViewController:registFirstVC animated:YES];
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
}

- (void)countDown
{
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:self.lastAuthCodeDate];
    DLog(@"time interval %lf", secondsBetween);
    if (secondsBetween > 180.f) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        self.countDownLabel.hidden = YES;
    }
    else{
        self.countDownLabel.hidden = NO;
        self.countDownLabel.text = [NSString stringWithFormat:@"%d秒", 180-(int)(secondsBetween+0.5)];
    }
}

- (void)stopTimer
{
    self.countDownLabel.hidden = YES;
    self.lastAuthCodeDate = nil;
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

#pragma mark - textfiled delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.telTextField) {
        self.tel = textField.text;
    }
    else if(textField == self.authCodeTextField){
        self.authCode = self.authCodeTextField.text;
    }
}


@end
