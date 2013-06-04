//
//  SettingTelViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-28.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingTelViewController.h"

@interface SettingTelViewController ()

@end

@implementation SettingTelViewController

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
    self.title = @"手机号码";
    self.view.backgroundColor = bgGreyColor;
    
    [self initNavBar];
    [self initScrollView];
    
    [self.authCodeButton addTarget:self action:@selector(getAuthCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saveTel:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_telTextField release];
    [_authCodeButton release];
    [_authCodeTextField release];
    [_saveButton release];
    [_countDownLabel release];
    [_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTelTextField:nil];
    [self setAuthCodeButton:nil];
    [self setAuthCodeTextField:nil];
    [self setSaveButton:nil];
    [self setCountDownLabel:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

#pragma mark - scrollview

- (void)initScrollView
{
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(320, 324);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.scrollView addGestureRecognizer:tap];
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
    [self stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - button method

- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [self.telTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
}

#pragma mark - change tel

- (void)getAuthCode:(UIButton *)sender
{
    DLog(@"get auth code");
    
    [self hideKeyBoard:nil];
    
    if (![Utility mobileNumIsValid:self.tel]) {
        return;
    }else{
        
        if (self.countDownTimer != nil) {
            [Utility showAlertWithTitle:@"三分钟内请勿重复获取"];
            return;
        }
        
        NSDictionary *para = @{@"path": @"sendCheckingCode.json", @"phoneNm": self.tel, @"type" : @"3"};
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
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            DLog(@"error %@", error);
        }];
    }
    
}

- (void)saveTel:(UIButton *)sender
{
    DLog(@"save tel");
    [self hideKeyBoard:nil];
    
    if (![self.authCode isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入验证码" andImageName:kErrorIcon];
        return;
    }
    else{
        NSDictionary *para = @{@"path": @"changeZsPhone.json",
                               @"phoneNm": self.tel,
                               @"verificationCode": self.authCode,
                               @"userid": [PersistenceHelper dataForKey:kUserId]};
        
        [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
        [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            if (RETURNCODE_ISVALID(json)) {
                
                [self stopTimer];
                
                [kAppDelegate showWithCustomAlertViewWithText:@"修改成功" andImageName:nil];
            }
            else{
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            DLog(@"error %@", error);
        }];
    }
}

- (void)stopTimer
{
    self.lastAuthCodeDate = nil;
    self.countDownLabel.hidden = YES;
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
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
    
    self.scrollView.frame = CGRectMake(0, 0, 320, 324);
    [UIView commitAnimations];
}

#pragma mark - textfield delgate

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
