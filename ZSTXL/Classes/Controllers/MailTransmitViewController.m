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
    
    
    
    //"answered": false,
    //"content": {
    //    "text": "好多图"
    //},
    //"deleted": false,
    //"draft": false,
    //"flagged": false,
    //"hasAttachment": false,
    //"messageNumber": 0,
    //"recent": false,
    //"seen": false,
    //"sender": "109981@boramail.com",
    //"subject": "转发:好多图",
    //"to": [
    //       "109981@boramail.com"
    //       ]
    
//    MessageBean *message = [[[MessageBean alloc] init] autorelease];
//    message.answered = @"0";
//    message.content = @{@"text": self.mail.content};
//    message.deleted = @"0";
//    message.draft = @"0";
//    message.flagged = @"0";
//    message.hasAttachment = @"0";
//    message.messageNumber = @"0";
//    message.recent = @"0";
//    message.seen = @"0";
//    message.sender = @"109981@boramail.com";
//    message.subject = self.mail.subject;
//    message.to = @[@"109981@boramail.com"];
    
//    [NSNumber numberWithBool:NO];
    
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
    
    
    
//    NSString *sender = [NSString stringWithFormat:@"%@@boramail.com", @"109981"];
//    NSString *to = [NSString stringWithFormat:@"109981@boramail"];
//    
//    NSDictionary *content = @{@"text": self.mail.content,
//                              @"attachment": [NSNull null],
//                              @"inline": [NSNull null]};
//    
//    NSDictionary *messageBean = @{@"sender": sender,
//                                  @"to": to,
//                                  @"cc": [NSNull null],
//                                  @"bcc": [NSNull null],
//                                  @"subject": self.mail.subject,
//                                  @"content": content};
    
    NSString *tmp = [[message JSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *para = @{@"path": @"relayMail.json",
                           @"username": @"109981",
                           @"password": @"123456",
                           @"relayMessage": tmp};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.1.199:8080/BLZTWeb/mail/"]];
//    [client postPath:@"relayMail.json" parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//        DLog(@"error %@", error);
//    }];
    
    
    [MailClient postWithParameters:para successBlock:^(id json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        DLog(@"%@", json);
        if (RETURNCODE_ISVALID(json)) {
            [kAppDelegate showWithCustomAlertViewWithText:@"转发成功" andImageName:nil];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:[json objForKey:@"returnMessage"] andImageName:kErrorIcon];
        }
    } failure:^{
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
}


@end
