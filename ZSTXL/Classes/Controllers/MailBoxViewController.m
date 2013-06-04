//
//  MailBoxViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailBoxViewController.h"
#import "MailCell.h"
#import "MailSelectorView.h"
#import "MailInfoViewController.h"

@interface MailBoxViewController ()

@end

@implementation MailBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [kAppDelegate.tabController hidesTabBar:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mailSelectorArray = @[@"MailSelectorSent", @"MailSelectorDraft", @"MailSelectorDelete", @"MailSelectorTrash"];
    
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
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
    
    TitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:nil options:nil] lastObject];
    titleView.title = @"收件箱";
    titleView.delegate = self;
    self.navigationItem.titleView = titleView;
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [kAppDelegate.tabController hidesTabBar:NO animated:YES];
}

- (void)titleViewTap
{
    DLog(@"tap title view");
//    MailSelectorView *mailSelectorView = [[[NSBundle mainBundle] loadNibNamed:@"MailSelectorView" owner:nil options:nil] lastObject];
//    mailSelectorView.frame = CGRectMake(160, -5, 100, 150);
//    mailSelectorView.delegate = self;
//    [self.view addSubview:mailSelectorView];
    self.mailSentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mailSentButton.frame = CGRectMake(180, 50, 88, 48);
    [self.mailSentButton setBackgroundImage:[UIImage imageNamed:@"mail_sent_texture"] forState:UIControlStateNormal];
    [self.mailSentButton setBackgroundImage:[UIImage imageNamed:@"mail_sent_texture_p"] forState:UIControlStateHighlighted];
    [self.mailSentButton setTitle:@"已发送" forState:UIControlStateNormal];
    [self.mailSentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mailSentButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.mailSentButton addTarget:self action:@selector(mailSent) forControlEvents:UIControlEventTouchUpInside];
    [kAppDelegate.window addSubview:self.mailSentButton];
    
}

- (void)mailSent
{
    [self.mailSentButton removeFromSuperview];
}

#pragma mark - request mail

- (void)requestMail
{
    
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataSourceArray.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MailCell";
    MailCell *cell = (MailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MailCell" owner:nil options:nil] lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(MailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailInfoViewController *mailInfoVC = [[[MailInfoViewController alloc] init] autorelease];
    [self.navigationController pushViewController:mailInfoVC animated:YES];
}

#pragma mark - mail selector view delegate

- (void)MailSelectorChooseIndexPath:(NSIndexPath *)indexPath
{
    SEL sel = NSSelectorFromString([self.mailSelectorArray objectAtIndex:indexPath.row]);
    [self performSelector:sel];
}

- (void)MailSelectorSent
{
    DLog(@"mail sent");
}

- (void)MailSelectorDraft
{
    DLog(@"mail draft");
}

- (void)MailSelectorDelete
{
    DLog(@"mail delete");
}

- (void)MailSelectorTrash
{
    DLog(@"mail trash");
}


- (IBAction)mailTransmit:(UIButton *)sender
{
    
}

- (IBAction)mailRefresh:(UIButton *)sender
{
    
}

- (IBAction)mailDelete:(UIButton *)sender
{
    
}

- (IBAction)mailWrite:(UIButton *)sender
{
    
}
@end