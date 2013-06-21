//
//  TheNewMessageViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "TheNewMessageViewController.h"
#import "TheNewMessageCell.h"
#import "TalkViewController.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    if ([kAppDelegate.userId isEqualToString:@"0"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"nav_login_button"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"nav_login_button_p"] forState:UIControlStateHighlighted];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 54, 32);
        
        UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
        self.navigationItem.rightBarButtonItem = item;
    }
    else{
        [self requestData];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavBar];
    
    self.tableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-49);
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = bgGreyColor;
    
    
    self.dataSourceArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    UIImageView *titleImage = [[[UIImageView alloc] initWithImage:[UIImage imageByName:@"mark"]] autorelease];
    titleImage.frame = CGRectMake(0, 0, 31, 32);
    self.navigationItem.titleView = titleImage;
}

- (void)login:(UIButton *)button
{
    LoginViewController *loginVC = [[[LoginViewController alloc] init] autorelease];
    loginVC.delegate = self;
    CustomNavigationController *nav = [[[CustomNavigationController alloc] initWithRootViewController:loginVC] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
}

#pragma mark - request Data

- (void)requestData
{
//    getNewMessageList.json
    NSDictionary *para = @{@"path": @"getNewMessageList.json",
                           @"page": @"0",
                           @"maxrow": @"2000",
                           @"userid": kAppDelegate.userId};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
       
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        
        DLog(@"json %@", json);
        
        if (RETURNCODE_ISVALID(json)) {
            
            if (self.dataSourceArray.count > 0) {
                [self.dataSourceArray removeAllObjects];
            }
            
            
            NSArray *array = [json objForKey:@"MessagePeoperList"];
            [self.dataSourceArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
    
}

#pragma mark - login delegate

- (void)loginFinished
{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
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
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    [cell.avatar setImageWithURL:[NSURL URLWithString:[dict objForKey:@"picturelinkurl"]] placeholderImage:[UIImage imageNamed:@"avatar"]];
    cell.nameLabel.text = [dict objForKey:@"username"];
    cell.contentLabel.text = [dict objForKey:@"content"];
    cell.dateLabel.text = [dict objForKey:@"createtime"];
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


@end
