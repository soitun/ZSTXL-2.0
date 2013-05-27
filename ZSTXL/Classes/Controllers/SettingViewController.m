//
//  SettingViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "CustomCellBackgroundView.h"
#import "PersonBasicInfoSettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    [super viewWillAppear:animated];
    [kAppDelegate.tabController hidesTabBar:YES animated:YES];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [super viewWillDisappear:animated];
//    [kAppDelegate.tabController hidesTabBar:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.tableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    [self initNavBar];
    [self initTableViewData];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    
    
    UIButton *logoffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoffButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoffButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoffButton setBackgroundImage:[UIImage imageNamed:@"logoff"] forState:UIControlStateNormal];
    [logoffButton setBackgroundImage:[UIImage imageNamed:@"logoff_p"] forState:UIControlStateHighlighted];
    logoffButton.frame = CGRectMake(15, 10, 289, 48);
    [logoffButton addTarget:self action:@selector(logoff:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoffButton];
    
    [self.tableView setTableFooterView:footerView];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
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
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [kAppDelegate.tabController hidesTabBar:NO animated:YES];
}

#pragma mark - table view data

- (void)initTableViewData
{
    NSArray *nameArr1 = @[@"个人信息设置"];
    NSArray *nameArr2 = @[@"提示音", @"修改密码", @"工作时间"];
    NSArray *nameArr3 = @[@"让附近的好友查看我", @"删除所有聊天记录", @"邀请好友加入通讯录", @"是否让您的好友、客户电话联系您！"];
    NSArray *nameArr4 = @[@"功能介绍", @"帮助反馈", @"版本信息"];
    self.settingInfo = [NSMutableArray arrayWithObjects:nameArr1, nameArr2, nameArr3, nameArr4, nil];
    
    NSArray *selArr1 = @[@"personInfoSetting"];
    NSArray *selArr2 = @[@"toneSwitch", @"changePasswd", @"workTime"];
    NSArray *selArr3 = @[@"findMe", @"deleteChatRecord", @"inviteFriend", @"telConnect"];
    NSArray *selArr4 = @[@"functionIntro", @"feedBack", @"version"];
    
    self.selectorArray = [NSMutableArray arrayWithObjects:selArr1, selArr2, selArr3, selArr4, nil];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.settingInfo objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SettingCell";
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.frame = CGRectMake(0, 0, 320, 44);

    CustomCellBackgroundViewPosition pos;
    
    if ([[self.settingInfo objectAtIndex:indexPath.section] count] == 1) {
        pos = CustomCellBackgroundViewPositionSingle;
    }
    else{
        if (indexPath.row == [[self.settingInfo objectAtIndex:indexPath.section] count]-1) {
            pos = CustomCellBackgroundViewPositionBottom;
        }
        else if (indexPath.row == 0){
            pos = CustomCellBackgroundViewPositionTop;
        }
        else{
            pos = CustomCellBackgroundViewPositionMiddle;
        }
    }
    

    
    CustomCellBackgroundView *customCellBgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
    customCellBgView.position = pos;
    customCellBgView.cornerRadius = 5.f;
    customCellBgView.fillColor = [UIColor whiteColor];
    customCellBgView.borderColor = kCellBorderColor;
    cell.backgroundView = customCellBgView;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[self.settingInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    if (indexPath.section == 2 && indexPath.row == 3) {
//        cell.selectImage.hidden = NO;
//        cell.selectImage.frame = CGRectMake(260, 15, 14, 14);
//        cell.selectImage.image = [UIImage imageNamed:@"login_select"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView bringSubviewToFront:cell.selectImage];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_select"]];
        image.frame = CGRectMake(262, 15, 14, 14);
        cell.selectImage = image;
        [cell.contentView addSubview:image];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    ((CustomCellBackgroundView *)(cell.backgroundView)).fillColor = kCellSelectColor;
    [((CustomCellBackgroundView *)(cell.backgroundView)) setNeedsDisplay];
    NSString *selName = [[self.selectorArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    SEL sel = NSSelectorFromString(selName);
    [self performSelector:sel];

}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
//    ((CustomCellBackgroundView *)(cell.backgroundView)).fillColor = [UIColor whiteColor];
//    [((CustomCellBackgroundView *)(cell.backgroundView)) setNeedsDisplay];
//}


#pragma mark - tableview selector

- (void)personInfoSetting
{
    DLog(@"personInfoSetting");
    PersonBasicInfoSettingViewController *personBasicInfoSettingVC = [[PersonBasicInfoSettingViewController alloc] init];
    [self.navigationController pushViewController:personBasicInfoSettingVC animated:YES];
    [personBasicInfoSettingVC release];
}

- (void)toneSwitch
{
    DLog(@"toneSwitch");
}

- (void)changePasswd
{
    DLog(@"changePasswd");
}

- (void)workTime
{
    DLog(@"workTime");
}

- (void)findMe
{
    DLog(@"findMe");
}

- (void)deleteChatRecord
{
    DLog(@"deleteChatRecord");
}

- (void)inviteFriend
{
    DLog(@"inviteFriend");
}

- (void)telConnect
{
    DLog(@"telConnect");
}

- (void)functionIntro
{
    DLog(@"functionIntro");
}

- (void)feedBack
{
    DLog(@"feedBack");
}

- (void)version
{
    DLog(@"version");
}


#pragma mark - log off

- (void)logoff:(UIButton *)sender
{
    DLog(@"logoff");
}


@end
