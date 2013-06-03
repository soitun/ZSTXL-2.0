//
//  MailInfoViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailInfoViewController.h"
#import "MailWriteViewController.h"


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
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_titleLabel release];
    [_avatar release];
    [_senderMailLabel release];
    [_reveiverNameLabel release];
    [_receiverMailLabel release];
    [_dateLabel release];
    [_mailContentTextView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setAvatar:nil];
    [self setSenderMailLabel:nil];
    [self setReveiverNameLabel:nil];
    [self setReceiverMailLabel:nil];
    [self setDateLabel:nil];
    [self setMailContentTextView:nil];
    [super viewDidUnload];
}
- (IBAction)mailTransmit:(UIButton *)sender
{
    
}

- (IBAction)mailDelete:(UIButton *)sender
{
    
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
}

- (void)mailNext
{
    DLog(@"mail next");
}



@end
