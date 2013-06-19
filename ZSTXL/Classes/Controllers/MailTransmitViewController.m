//
//  MailTransmitViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-16.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailTransmitViewController.h"
#import "UserDetail.h"
#import "MessageBean.h"
#import "OutboxMail.h"

@interface MailTransmitViewController ()

@end

@implementation MailTransmitViewController

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
    self.title = @"转发";
    self.view.backgroundColor = bgGreyColor;
    
    for (id subview in self.contentWebView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    }
    
    self.subjectTextField.text = self.mail.subject;
    self.receiverLabel.text = self.mail.to;
    [self.contentWebView loadHTMLString:self.mail.content baseURL:nil];
    
    [self.addFriendButton addTarget:self action:@selector(addFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_receiverLabel release];
    [_addFriendButton release];
    [_subjectTextField release];
    [_contentWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setReceiverLabel:nil];
    [self setAddFriendButton:nil];
    [self setSubjectTextField:nil];
    [self setContentWebView:nil];
    [super viewDidUnload];
}

#pragma mark - button method

- (void)addFriendAction:(UIButton *)sender
{
    MailAddFriendViewController *mailAddFriendVC = [[[MailAddFriendViewController alloc] init] autorelease];
    mailAddFriendVC.delegate = self;
    [self.navigationController pushViewController:mailAddFriendVC animated:YES];
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
    
    NSDictionary *message = @{@"answered": [NSNumber numberWithBool:NO],
                              @"content": @{@"text": self.mail.content},
                              @"deleted": [NSNumber numberWithBool:NO],
                              @"draft": [NSNumber numberWithBool:NO],
                              @"flagged": [NSNumber numberWithBool:NO],
                              @"hasAttachment": [NSNumber numberWithBool:NO],
                              @"messageNumber": [NSNumber numberWithInt:0],
                              @"recent": [NSNumber numberWithBool:NO],
                              @"seen": [NSNumber numberWithBool:NO],
                              @"sender": @"109981@boramail.com",
                              @"subject": self.mail.subject,
                              @"to": @[@"109981@boramail.com"]};
    
    
    NSString *tmp = [[message JSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *para = @{@"path": @"relayMail.json",
                           @"username": @"109981",
                           @"password": @"123456",
                           @"relayMessage": tmp};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [MailClient postWithParameters:para successBlock:^(id json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        DLog(@"%@", json);
        if (RETURNCODE_ISVALID(json)) {
            [kAppDelegate showWithCustomAlertViewWithText:@"转发成功" andImageName:nil];
            OutboxMail *mail = [OutboxMail createEntity];
            mail.subject = self.mail.subject;
            mail.content = self.mail.content;
            mail.sender = [NSString stringWithFormat:@"%@@boramail.com", kAppDelegate.userId];
            
            NSMutableString *to = [NSMutableString string];
            [to appendFormat:@"%@,", self.to];
            
            if ([to isValid]) {
                mail.to  = [to substringToIndex:to.length-1];
            }
            
            mail.sentDate = [NSNumber numberWithLong:[[NSData data] timeIntervalSince1970]];
            
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

#pragma mark - mail add friend delegate

- (void)mailAddFriend:(Contact *)contact
{
    NSString *tmp = [NSString stringWithFormat:@"%@@boramail.com", contact.userid];
    self.to = tmp;
    self.receiverLabel.text = contact.username;
}


@end
