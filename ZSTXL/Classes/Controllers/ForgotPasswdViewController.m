//
//  ForgotPasswdViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ForgotPasswdViewController.h"
#import "SendAuthViewController.h"

@interface ForgotPasswdViewController ()

@end

@implementation ForgotPasswdViewController

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
    self.title = @"忘记密码";
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_telTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTelTextField:nil];
    [super viewDidUnload];
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


- (IBAction)nextStep:(UIButton *)sender
{
    DLog(@"下一步");
    if (![self.telTextField.text isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (![self.telTextField.text isMobileNumber]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [self.view endEditing:YES];
    SendAuthViewController *sendAuthVC = [[[SendAuthViewController alloc] init] autorelease];
    sendAuthVC.tel = self.telTextField.text;
    [self.navigationController pushViewController:sendAuthVC animated:YES];
    
}
@end
