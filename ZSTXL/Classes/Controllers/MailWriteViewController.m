//
//  MailWriteViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailWriteViewController.h"

@interface MailWriteViewController ()

@end

@implementation MailWriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"写邮件";
    
    [self initScrollView];
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
    
    [_reveiverLabel release];
    [_subjectTextField release];
    [_scrollView release];
    [_contentTextView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setReveiverLabel:nil];
    [self setSubjectTextField:nil];
    [self setScrollView:nil];
    [self setContentTextView:nil];
    [super viewDidUnload];
}

#pragma mark - scroll view

- (void)initScrollView
{
    self.scrollView.contentSize = CGSizeMake(320, SCREEN_HEIGHT-64);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView)];
    [self.scrollView addGestureRecognizer:tap];
}

- (void)tapScrollView
{
    [self.contentTextView resignFirstResponder];
    [self.subjectTextField resignFirstResponder];
}

#pragma mark - nav bar

- (void)initNavBar
{
    UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setBackgroundImage:[UIImage imageByName:@"nav_login_button"] forState:UIControlStateNormal];
    [lButton setBackgroundImage:[UIImage imageByName:@"nav_login_button_p"] forState:UIControlStateHighlighted];
    [lButton setTitle:@"取消" forState:UIControlStateNormal];
    [lButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [lButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lButton addTarget:self action:@selector(cancelSendMail) forControlEvents:UIControlEventTouchUpInside];
    lButton.frame = CGRectMake(0, 0, 54, 32);
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:lButton] autorelease];
    self.navigationItem.leftBarButtonItem = lBarButton;
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:[UIImage imageNamed:@"nav_login_button"] forState:UIControlStateNormal];
    [rButton setBackgroundImage:[UIImage imageNamed:@"nav_login_button_p"] forState:UIControlStateHighlighted];
    [rButton setTitle:@"发送" forState:UIControlStateNormal];
    [rButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [rButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    rButton.frame = CGRectMake(0, 0, 54, 32);
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:rButton] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
}

- (void)cancelSendMail
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMail
{
    DLog(@"send mail");
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

@end
