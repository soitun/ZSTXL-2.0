//
//  TheNewMessageViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "TheNewMessageViewController.h"
#import "LoginViewController.h"
#import "TheNewMessageCell.h"

@interface TheNewMessageViewController ()

@end

@implementation TheNewMessageViewController

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
    // Do any additional setup after loading the view from its nib.
    [self initNavBar];

    self.tableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-48);
    self.dataSourceArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64);
}

- (void)initNavBar
{
    UIImageView *titleImage = [[[UIImageView alloc] initWithImage:[UIImage imageByName:@"mark"]] autorelease];
    titleImage.frame = CGRectMake(0, 0, 31, 32);
    self.navigationItem.titleView = titleImage;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"login_button_p"] forState:UIControlStateHighlighted];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 54, 32);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)login:(UIButton *)button
{
    LoginViewController *loginVC = [[[LoginViewController alloc] init] autorelease];
    CustomNavigationController *nav = [[[CustomNavigationController alloc] initWithRootViewController:loginVC] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return  self.dataSourceArray.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"theNewMessageCell";
    TheNewMessageCell *cell = (TheNewMessageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TheNewMessageCell" owner:nil options:nil] lastObject];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)configureCell:(TheNewMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TheNewMessageCell *cell = (TheNewMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.chatIcon.image = [UIImage imageNamed:@"chat_icon"];
    cell.messageIcon.image = [UIImage imageNamed:@"message"];
    cell.mailIcon.image = [UIImage imageNamed:@"mail"];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TheNewMessageCell *cell = (TheNewMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.chatIcon.image = [UIImage imageNamed:@"chat_icon_on"];
    cell.messageIcon.image = [UIImage imageNamed:@"message_on"];
    cell.mailIcon.image = [UIImage imageNamed:@"mail_on"];
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
@end
