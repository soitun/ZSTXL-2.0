//
//  SendAuthViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SendAuthViewController.h"
#import "PasswdViewController.h"

@interface SendAuthViewController ()

@end

@implementation SendAuthViewController

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
    self.title = @"忘记密码";
    [self.telLabel setTextColor:kContentBlueColor];
    self.telLabel.text = self.tel;
    [self initNavBar];
    
    
    //倒计时
    self.lastAuthcodeDate = [PersistenceHelper dataForKey:@"lastAuthcodeDate"];
    if (self.lastAuthcodeDate != nil) {
        self.countDownTimer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_authcodeTextField release];
    [_telLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAuthcodeTextField:nil];
    [self setTelLabel:nil];
    [super viewDidUnload];
}


#pragma mark - button method

- (IBAction)sendAuth:(UIButton *)sender
{
    DLog(@"发送验证码");
    self.lastAuthcodeDate = [PersistenceHelper dataForKey:@"lastAuthcodeDate"];
    if (self.lastAuthcodeDate != nil) {
        self.countDownTimer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    
    
    NSDictionary *para = @{@"phoneNm": self.tel, @"type" : @"1", @"path": @"sendCheckingCode.json"};
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        if (RETURNCODE_ISVALID(json)) {
            DLog(@"%@", json);
            self.lastAuthcodeDate = [NSDate date];
            [PersistenceHelper setData:self.lastAuthcodeDate forKey:@"lastAuthcodeDate"];
        }
        else{
            DLog(@"message %@", GET_RETURNMESSAGE(json));
        }
    } failure:^(NSError *error) {
        DLog(@"%@", error);
    }];
}

- (void)countDown
{
    
}

- (IBAction)nextStep:(UIButton *)sender
{
    if (![self.authcodeTextField.text isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入验证码" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [self.view endEditing:YES];
    
    PasswdViewController *passwdVC = [[[PasswdViewController alloc] init] autorelease];
    [self.navigationController pushViewController:passwdVC animated:YES];
}




#pragma mark - nav

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
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    
    self.view.frame = CGRectMake(0, -40, 320, SCREEN_HEIGHT-64);
    
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
    
    self.view.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64);
    [UIView commitAnimations];
}

@end
