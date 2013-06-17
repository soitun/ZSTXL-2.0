//
//  MailInfoViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailInfoViewController.h"
#import "MailWriteViewController.h"
#import "UserDetail.h"
#import "MailTransmitViewController.h"


@interface MailInfoViewController ()

@end

@implementation MailInfoViewController

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
    self.title = @"收件箱";
    
    for (id subview in self.mailWebView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    }
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(c, red);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 5.0f, 5.0f);
    CGContextAddLineToPoint(c, 50.0f, 50.0f);
    CGContextStrokePath(c);
    
    
    [self showBasicMail];
    [self initNavBar];
    [self getMailFromDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_titleLabel release];
    [_avatar release];
    [_reveiverNameLabel release];
    [_dateLabel release];
    [_mailWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setAvatar:nil];
    [self setReveiverNameLabel:nil];
    [self setDateLabel:nil];
    [self setMailWebView:nil];
    [super viewDidUnload];
}

#pragma mark - show basi mail info

- (void)showBasicMail
{
    self.titleLabel.text = self.mail.subject;
    
    NSString *senderName = [[self.mail.sender componentsSeparatedByString:@"@"] objectAtIndex:0];
    self.senderNameLabel.text = senderName;
    
    NSString *toName = nil;
    if (self.isInbox) {
        toName = [Utility getMyInfo].userDetail.username;
    }
    else{
        toName = self.mail.to;
    }
    
    self.reveiverNameLabel.text = toName;
    
    self.dateLabel.text = self.mail.sentDateStr;
}

#pragma mark - request data

- (void)getMailFromDB
{
    if ([self.mail.content isValid]) {
        [self.mailWebView loadHTMLString:self.mail.content baseURL:nil];
        self.mail.seen = @"1";
        PERFORM_SELECTOR_WITH_OBJECT(self.delegate, @selector(mailInfoHasRead:), self.mail);
    }
    else{
        [self requestData];
    }
}

- (void)requestData
{
    NSString *box = nil;
    if (self.isInbox) {
        box = @"INBOX";
    }
    else{
        box = @"Sent";
    }
    
    NSDictionary *para = @{@"path": @"mailContent.json",
                           @"messageId": self.mail.messageId,
                           @"folderName": box,
                           @"username": @"109981",
                           @"password": @"123456"};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [MailClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//        DLog(@"json %@", json);
        if (RETURNCODE_ISVALID(json)) {
            [self parseMail:json];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
}

- (void)parseMail:(NSDictionary *)json
{
    NSString *content = [json objForKeyPath:@"messageBean.content.text"];
    self.mail.content = content;
    self.mail.seen = @"1";
    DB_SAVE();
    
    [self.mailWebView loadHTMLString:content baseURL:nil];
    PERFORM_SELECTOR_WITH_OBJECT(self.delegate, @selector(mailInfoHasRead:), self.mail);
    DLog(@"content %@", content);
}

#pragma mark - button method

- (IBAction)mailTransmit:(UIButton *)sender
{
    //转发
    MailTransmitViewController *mailTransmitVC = [[[MailTransmitViewController alloc] init] autorelease];
    mailTransmitVC.mail = self.mail;
    [self.navigationController pushViewController:mailTransmitVC animated:YES];
}

- (IBAction)mailDelete:(UIButton *)sender
{
    //如果有下一封邮件则进入下一封邮件，没有回之前页面
    NSInteger index = [self.mailArray indexOfObject:self.mail];
    if (index == self.mailArray.count-1) {
        PERFORM_SELECTOR_WITH_OBJECT(self.delegate, @selector(mailInfoHasDelete:), self.mail);
        [self popVC:nil];
    }
    else{
        Mail *mail = self.mail;
        [self mailNext];
        PERFORM_SELECTOR_WITH_OBJECT(self.delegate, @selector(mailInfoHasDelete:), mail);
        
    }
    
}

- (IBAction)mailWrite:(UIButton *)sender
{
    MailWriteViewController *mailWriteVC = [[[MailWriteViewController alloc] init] autorelease];
    [self.navigationController pushViewController:mailWriteVC animated:YES];
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
    
    MailNextPreView *mailNextPreView = [[[NSBundle mainBundle] loadNibNamed:@"MailNextPreView" owner:nil options:nil] lastObject];
    mailNextPreView.delegate = self;
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:mailNextPreView] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
    
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - mailnextpre delegate

- (void)mailPre
{
    DLog(@"mail pre");
    NSInteger index = [self.mailArray indexOfObject:self.mail];
    if (index == 0) {
        [kAppDelegate showWithCustomAlertViewWithText:@"到顶了，亲" andImageName:nil];
        return;
    }
    
    index--;
    self.mail = [self.mailArray objectAtIndex:index];
    [self showBasicMail];
    [self getMailFromDB];
}

- (void)mailNext
{
    DLog(@"mail next");
    NSInteger index = [self.mailArray indexOfObject:self.mail];
    if (index == self.mailArray.count-1){
        [kAppDelegate showWithCustomAlertViewWithText:@"没有了，亲" andImageName:nil];
        return;
    }
    
    index++;
    self.mail = [self.mailArray objectAtIndex:index];
    [self showBasicMail];
    [self getMailFromDB];
}

@end
