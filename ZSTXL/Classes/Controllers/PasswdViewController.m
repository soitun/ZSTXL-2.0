//
//  PasswdViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PasswdViewController.h"

@interface PasswdViewController ()

@end

@implementation PasswdViewController

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
    self.title = @"重置密码";
    self.scrollView.contentSize = CGSizeMake(320, 286);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.scrollView addGestureRecognizer:tap];
    
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
    [_passwdField release];
    [_rePasswdField release];
    [_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPasswdField:nil];
    [self setRePasswdField:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
- (IBAction)confirm:(UIButton *)sender
{
    NSString *password = self.passwdField.text;
    if (![password isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入密码" andImageName:kErrorIcon];
        return;
    } else {
        if ([password length] < 6) {
            [kAppDelegate showWithCustomAlertViewWithText:@"密码不得小于6位" andImageName:kErrorIcon];
            return;
        }
    }
    
    NSString *rePassword = self.rePasswdField.text;
    if (![rePassword isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请再次输入密码" andImageName:kErrorIcon];
        return;
    } else {
        if (![rePassword isEqualToString:password]) {
            return;
        }
    }
    
    DLog(@"确认重置密码");
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

#pragma mark - tap

- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [self.passwdField resignFirstResponder];
    [self.rePasswdField resignFirstResponder];
}

@end
