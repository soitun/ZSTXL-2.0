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
#import "SettingWorkTimeViewController.h"
#import "AboutViewController.h"
#import "InviteFriendViewController.h"
#import "ModifyPasswdViewController.h"

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
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = bgGreyColor;
    self.toneOn = YES;
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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self requestAllowTel];
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

#pragma mark - request setting info

- (void)requestAllowTel
{
    NSDictionary *para = @{@"path": @"getAllowtelStatus.json",
                           @"userid": kAppDelegate.userId};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            self.allowFriendContact = [[json objForKey:@"userAllowtel"] intValue];
            [self.tableView reloadData];
            DLog(@"json %@", json);
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        DLog(@"err %@", error);
    }];
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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:nil options:nil] lastObject];
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
        cell.selectImage.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.delegate = self;
        cell.onLabel.hidden = YES;
        cell.offLabel.hidden = YES;
        
        if (self.allowFriendContact) {
            cell.selectImage.image = [UIImage imageNamed:@"login_select"];
        }
        else{
            cell.selectImage.image = [UIImage imageNamed:@"login_noselect"];
        }
        
    } else if ((indexPath.section == 1 && indexPath.row == 0) || (indexPath.section == 2 && indexPath.row == 0)) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectImage.hidden = YES;
        cell.switchImage.hidden = NO;
        cell.delegate = self;
        cell.onLabel.hidden = NO;
        cell.offLabel.hidden = NO;

    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.switchImage.hidden = YES;
        cell.selectImage.hidden = YES;
        cell.onLabel.hidden = YES;
        cell.offLabel.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ((indexPath.section == 2 && indexPath.row == 3) ||
        (indexPath.section == 2 && indexPath.row == 1)) {
        
    }
    else {
        ((CustomCellBackgroundView *)(cell.backgroundView)).fillColor = kCellSelectColor;
        [((CustomCellBackgroundView *)(cell.backgroundView)) setNeedsDisplay];
    }
    
    
    NSString *selName = [[self.selectorArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    SEL sel = NSSelectorFromString(selName);
    [self performSelector:sel];
}

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
    ModifyPasswdViewController *modifyPasswdVC = [[[ModifyPasswdViewController alloc] init] autorelease];
    [self.navigationController pushViewController:modifyPasswdVC animated:YES];
}

- (void)workTime
{
    DLog(@"workTime");
    SettingWorkTimeViewController *settingWorkTimeVC = [[[SettingWorkTimeViewController alloc] init] autorelease];
    [self.navigationController pushViewController:settingWorkTimeVC animated:YES];
}

- (void)findMe
{
    DLog(@"findMe");
}

- (void)deleteChatRecord
{
    DLog(@"deleteChatRecord");
    DeleteChatView *deleteChatView = [[DeleteChatView alloc] init];
    deleteChatView.delegate = self;
    [deleteChatView showInView:kAppDelegate.window];
}

- (void)inviteFriend
{
    DLog(@"inviteFriend");
    InviteFriendViewController *inviteFriendVC = [[[InviteFriendViewController alloc] init] autorelease];
    [self.navigationController pushViewController:inviteFriendVC animated:YES];
}

- (void)telConnect
{
    DLog(@"telConnect");
    
    NSDictionary *para = @{@"path": @"changeAllowtelStatus.json",
                           @"allowtelStatus": [NSString stringWithFormat:@"%d", self.allowFriendContact],
                           @"userid": kAppDelegate.userId};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            [self.tableView reloadData];
            self.allowFriendContact = 1 - self.allowFriendContact;
            DLog(@"json %@", json);
        }
        else{
            
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        DLog(@"err %@",error);
    }];
    
    
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
    
    AboutViewController *aboutVC = [[[AboutViewController alloc] init] autorelease];
    [self.navigationController pushViewController:aboutVC animated:YES];
}


#pragma mark - log off

- (void)logoff:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    [alert release];
}

#pragma mark - setting cell delegate

- (void)switchOnOff:(SettingCell *)cell
{
    self.toneOn = !self.toneOn;
    if (self.toneOn) {
        cell.switchImage.image = [UIImage imageNamed:@"switch_on"];
    }
    else{
        cell.switchImage.image = [UIImage imageNamed:@"switch_off"];
    }
}

- (void)select:(SettingCell *)cell
{
    DLog(@"select");
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else{
        [PersistenceHelper setData:@"" forKey:KUserName];
        [PersistenceHelper setData:@"" forKey:kUserId];
        [kAppDelegate.tabController.tabBar selectTabAtIndex:1];
        [self popVC:nil];
    }
}

#pragma mark - delete view delegate

- (void)deleteChat
{
    
}

- (void)deleteChatCancel
{
    
}

@end
