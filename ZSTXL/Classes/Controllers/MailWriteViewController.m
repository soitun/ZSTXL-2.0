//
//  MailWriteViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailWriteViewController.h"
#import "MailAddFriendViewController.h"
#import "OutboxMail.h"

#define kTextGrayColor [UIColor colorWithWhite:0.70 alpha:1]


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
    
    [self.addFriendButton addTarget:self action:@selector(addFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    self.contentTextView.text = @"内容";
    self.contentTextView.textColor = kTextGrayColor;
    
    
    UIImage *image = [UIImage stretchableImage:@"setting_textfield_bg.png" leftCap:10 topCap:20];
    self.contentImageView.image = image;
    
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
    
    [_receiverLabel release];
    [_subjectTextField release];
    [_scrollView release];
    [_contentTextView release];
    [_addFriendButton release];
    [_contentImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setReceiverLabel:nil];
    [self setSubjectTextField:nil];
    [self setScrollView:nil];
    [self setContentTextView:nil];
    [self setAddFriendButton:nil];
    [self setContentImageView:nil];
    [super viewDidUnload];
}

#pragma mark - button method

- (void)addFriendAction:(UIButton *)sender
{
    MailAddFriendViewController *mailAddFriendVC = [[[MailAddFriendViewController alloc] init] autorelease];
    mailAddFriendVC.delegate = self;
    [self.navigationController pushViewController:mailAddFriendVC animated:YES];
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
    [self hideKeyBoard];

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
    [self hideKeyBoard];
    if (![self.subject isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"主题为空，确认发送" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        [alert show];
        [alert release];
        return;
    }
    else{
        [self didSendMail];
    }
}

- (void)didSendMail
{
    //发送邮件	sendMail	get/post	username	用户名	password	密码	sendMessage	发送的消息(MessageBean)											"returnCode:String returnMessage:String"
    
    if (([self.contentTextView.text isEqualToString:@"内容"]) && (self.contentTextView.textColor == kTextGrayColor)) {
        self.content = @"";
    }
    
    //注意 目前为测试状态，只能用109981发和接
    NSDictionary *message = @{@"answered": [NSNumber numberWithBool:NO],
                              @"content": @{@"text": self.content},
                              @"deleted": [NSNumber numberWithBool:NO],
                              @"draft": [NSNumber numberWithBool:NO],
                              @"flagged": [NSNumber numberWithBool:NO],
                              @"hasAttachment": [NSNumber numberWithBool:NO],
                              @"messageNumber": [NSNumber numberWithInt:0],
                              @"recent": [NSNumber numberWithBool:NO],
                              @"seen": [NSNumber numberWithBool:NO],
                              @"sender": @"109981@boramail.com",
                              @"subject": self.subject,
                              @"to": @[@"109981@boramail.com"]};
    
    
    NSString *tmp = [[message JSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *para = @{@"path": @"sendMail.json",
                           @"username": @"109981",
                           @"password": @"123456",
                           @"sendMessage": tmp};
    
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    
    [MailClient postWithParameters:para successBlock:^(id json) {
        DLog(@"json %@", json);
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            
            [kAppDelegate showWithCustomAlertViewWithText:@"发送成功" andImageName:nil];
            
            OutboxMail *mail = [OutboxMail createEntity];
            mail.subject = self.subject;
            mail.content = self.content;
            mail.sender = [NSString stringWithFormat:@"%@@boramail.com", kAppDelegate.userId];
            
            NSMutableString *to = [NSMutableString string];
            [to appendFormat:@"%@,", self.to];
            
            if ([to isValid]) {
                mail.to  = [to substringToIndex:to.length-1];
            }
            
            mail.sentDate = [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]];
        
            NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setDateFormat:@"MM月dd日"];
            
            mail.sentDateStr = [formatter stringFromDate:[NSDate date]];
            mail.seen = [NSNumber numberWithBool:false];
            mail.localDeleted = @"0";
            
            DB_SAVE();
            

            
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:[json objForKey:@"returnMessage"] andImageName:kErrorIcon];
        }
    } failure:^{
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - keyboard

- (void)hideKeyBoard
{
    [self.contentTextView resignFirstResponder];
    [self.subjectTextField resignFirstResponder];
}

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

#pragma mark - mail add friend delegate

- (void)mailAddFriend:(Contact *)contact
{
    NSString *tmp = [NSString stringWithFormat:@"%@@boramail.com", contact.userid];
    self.to = tmp;
    self.receiverLabel.text = contact.username;
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.subject = textField.text;
}

#pragma mark - textview delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"内容"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![textView.text isValid]) {
        textView.text = @"内容";
        textView.textColor = kTextGrayColor;
    }
    
    self.content = textView.text;
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else{
        [self didSendMail];
    }
}

@end
