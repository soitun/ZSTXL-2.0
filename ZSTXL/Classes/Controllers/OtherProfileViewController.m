//
//  OtherProfileViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "HomePageCell.h"
#import "FriendContact.h"
#import "LoginViewController.h"
#import "TalkViewController.h"
#import "CustomCellBackgroundView.h"

enum eAlertTag {
    commentAlert = 0,
    loginAlert,
};

@interface OtherProfileViewController ()

@end

@implementation OtherProfileViewController

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
    self.title = @"他的主页";
    self.titleArray = @[@"招商代理：", @"常驻地区：", @"类别偏好：", @"他的招商代理信息"];
    self.contentArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    self.isFriend = NO;
    
    [self initNavBar];
    [self initTableView];
    [self initTableHeader];
    [self initTableFooter];
    
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - user info

- (void)getUserInfo
{
    NSString *peoperid = self.contact.userid;   //好友id
    NSString *userid = [kAppDelegate userId];
    NSString *cityName = [PersistenceHelper dataForKey:kCityName];
    NSString *cityid = [[Utility getCityIdByCityName:cityName] cityId];
    NSString *provinceid = [[Utility getCityIdByCityName:cityName] proId];
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:peoperid, @"peoperid",
                              userid, @"userid",
                              cityid, @"cityid",
                              provinceid, @"provinceid",
                              @"getUserpageDetail.json", @"path", nil];
    
    
    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        if (RETURNCODE_ISVALID(json)) {
//            DLog(@"friend json data: %@", json);
            
            
            NSMutableString *areaString = [[NSMutableString alloc] init];
            NSArray *areaList = [json objectForKey:@"AreaList"];
            [areaList enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
                [areaString appendFormat:@"%@、", [cityDict objForKey:@"cityname"]];
                
            }];
            
            if ([areaString isValid]) {
                self.residentArea = [areaString substringToIndex:[areaString length]-1];
                [self.contentArray replaceObjectAtIndex:1 withObject:self.residentArea];
            }
            
            
            NSMutableString *preferString = [[NSMutableString alloc] init];
            NSArray *preferList = [json objectForKey:@"PreferList"];
            [preferList enumerateObjectsUsingBlock:^(NSDictionary *preferDict, NSUInteger idx, BOOL *stop) {
                
                [preferString appendFormat:@"%@、", [preferDict objForKey:@"prefername"]];
            }];
            
            if ([preferString isValid]) {
                self.pharmacologyCategory = [preferString substringToIndex:[preferString length]-1];
                [self.contentArray replaceObjectAtIndex:2 withObject:self.pharmacologyCategory];
            }
            
            NSDictionary *userDetail = [json objectForKey:@"UserDetail"];
            self.contact.autograph = [userDetail objForKey:@"autograph"];
            self.contact.col1 = [userDetail objForKey:@"col1"];
            self.contact.col2 = [userDetail objForKey:@"col2"];
            self.contact.col3 = [userDetail objForKey:@"col3"];
            self.contact.userid = [[userDetail objForKey:@"id"] stringValue];
            self.contact.invagency = [[userDetail objForKey:@"invagency"] stringValue];
            self.contact.mailbox = [userDetail objForKey:@"mailbox"];
            self.contact.picturelinkurl = [userDetail objForKey:@"picturelinkurl"];
            self.contact.remark = [userDetail objForKey:@"remark"];
            self.contact.tel = [userDetail objForKey:@"tel"];
            self.contact.type = [[userDetail objForKey:@"type"] stringValue];
            self.contact.username = [userDetail objForKey:@"username"];
            self.contact.userid = [[userDetail objForKey:@"id"] stringValue];
            self.contact.isreal = [[userDetail objForKey:@"isreal"] stringValue];
            self.contact.blacktype = [[userDetail objForKey:@"blacktype"] stringValue];
            
            NSString *zs = nil;
            switch (self.contact.invagency.intValue) {
                case 1:
                    zs = @"招商";
                    break;
                case 2:
                    zs = @"代理";
                    break;
                case 3:
                    zs = @"招商/代理";
                    break;
                default:
                    break;
            }
            [self.contentArray replaceObjectAtIndex:0 withObject:zs];
            
            DB_SAVE();
            
            [self showHisInfo];
            [self.tableView reloadData];
            
            
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)showHisInfo
{
    if (self.contact.type.intValue == 0) {
        self.isFriend = NO;
        [self.tableFooter.addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
    }
    else{
        self.isFriend = YES;
        [self.tableFooter.addFriendButton setTitle:@"删除好友" forState:UIControlStateNormal];
    }
    
    if ([self.contact.remark isValid]) {
        NSString *name = [NSString stringWithFormat:@"%@(%@)", self.contact.username, self.contact.remark];
        self.tableHeader.nameLabel.text = name;
    }
    else{
        self.tableHeader.nameLabel.text = self.contact.username;
    }
    
    self.tableHeader.userIdLabel.text = self.contact.userid;
    
    
    if ([self.contact.col2 isEqualToString:@"1"]) {
        self.tableHeader.xunVImage.hidden = NO;
    }
    else{
        self.tableHeader.xunVImage.hidden = YES;
    }
    
    if ([self.contact.blacktype isEqualToString:@"1"]) {
        [self.tableFooter.addBlackButton setTitle:@"从黑名单中移除" forState:UIControlStateNormal];
        self.isBlack = YES;
    }
    else{
        [self.tableFooter.addBlackButton setTitle:@"加入黑名单" forState:UIControlStateNormal];
        self.isBlack = NO;
    }
    
    [self.tableHeader.avatar setImageWithURL:[NSURL URLWithString:self.contact.picturelinkurl] placeholderImage:[UIImage imageNamed:@"home_icon"]];
    
}



- (BOOL)showLoginAlert
{
    BOOL shouldShow = NO;
    if ([[kAppDelegate userId] isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        alert.tag = loginAlert;
        [alert show];
        [alert release];
        shouldShow = YES;
    }
    return shouldShow;
}

#pragma mark - nav bar

- (void)initNavBar
{
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    
    UIBarButtonItem *addBlackBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBlacklist)];
    UIBarButtonItem *delBlackBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(delBlacklist)];
    self.navigationItem.rightBarButtonItems = @[addBlackBarButton, delBlackBarButton];
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    PERFORM_SELECTOR(self.delegate, @selector(otherProfileFriendRefresh));
}

#pragma mark - table view

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = kCellBorderColor;
//    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)initTableHeader
{
    self.tableHeader = [[[NSBundle mainBundle] loadNibNamed:@"OtherProfileHeader" owner:self options:nil] lastObject];
    self.tableHeader.delegate = self;
    self.tableView.tableHeaderView = self.tableHeader;
}

- (void)initTableFooter
{
//    CGFloat footerViewHeight = 0.f;
//    if (IS_IPHONE_5) {
//        footerViewHeight = 65.f;
//    }
//    else{
//        footerViewHeight = 55.f;
//    }
//    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, footerViewHeight)];
//    
//    self.addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
//    [self.addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.addFriendButton setBackgroundImage:[UIImage imageNamed:@"setting_confirm_l"] forState:UIControlStateNormal];
//    [self.addFriendButton setBackgroundImage:[UIImage imageNamed:@"setting_confirm_l_p"] forState:UIControlStateHighlighted];
//    if (IS_IPHONE_5) {
//        self.addFriendButton.frame = CGRectMake(15, (footerViewHeight-45)/2.f, 289, 45);
//    }
//    else{
//        self.addFriendButton.frame = CGRectMake(15, (footerViewHeight-45)/2.f, 289, 45);
//    }
//
//    [self.addFriendButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:self.addFriendButton];
    
    self.tableFooter = [[[NSBundle mainBundle] loadNibNamed:@"OtherProfileFooter" owner:self options:nil] lastObject];
    self.tableFooter.delegate = self;
    [self.tableView setTableFooterView:self.tableFooter];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IS_IPHONE_5) {
        if (section == 0) {
            return 20.f;
        }else{
            return 10.f;
        }
    }
    else{
        if (section == 0) {
            return 8.f;
        }else{
            return 4.f;
        }
    }

    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (IS_IPHONE_5) {
        return 10.f;
    }
    else{
        return 4.f;
    }
    
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    if (indexPath.section == 0) {
        height = 43.f;
    }
    else{
        height = 44.f;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (section == 0) {
        number = 1;
    }
    else{
        number = 4;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homePageCellId = @"HomePageCell";
    static NSString *contactCellId = @"OtherProfileContactCell";
    if (indexPath.section == 0) {
        OtherProfileContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:contactCellId];
        if (contactCell == nil) {
            contactCell = [[[NSBundle mainBundle] loadNibNamed:@"OtherProfileContactCell" owner:self options:nil] lastObject];
        }
        [Utility groupTableView:tableView addBgViewForCell:contactCell withCellPos:CustomCellBackgroundViewPositionSingle];
        contactCell.accessoryType = UITableViewCellAccessoryNone;
        contactCell.selectionStyle = UITableViewCellSelectionStyleNone;
        contactCell.delegate = self;
        return contactCell;
    }
    else{
        HomePageCell *homePageCell = [tableView dequeueReusableCellWithIdentifier:homePageCellId];
        if (homePageCell == nil) {
            homePageCell = [[[NSBundle mainBundle] loadNibNamed:@"HomePageCell" owner:self options:nil] lastObject];
        }
        [self configureCell:homePageCell atIndexPath:indexPath];
        return homePageCell;
    }
    
    return nil;
}

- (void)configureCell:(HomePageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.nameLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    CustomCellBackgroundViewPosition pos;
    if (indexPath.row == 0) {
        pos = CustomCellBackgroundViewPositionTop;
    }
    else if (indexPath.row == self.titleArray.count-1){
        pos = CustomCellBackgroundViewPositionBottom;
    }else{
        pos = CustomCellBackgroundViewPositionMiddle;
    }
    
    [Utility groupTableView:self.tableView addBgViewForCell:cell withCellPos:pos];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.detailLabel.text = [self.contentArray objectAtIndex:indexPath.row];
    [cell setNeedsDisplay];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - contact cell delegate

- (void)OtherProfileTel
{
    NSString *userTel = [Utility deCryptTel:self.contact.tel withUserId:self.contact.userid];
    
    NSString *telStr = [NSString stringWithFormat:@"tel://%@", userTel];
    UIWebView *callPhoneWebVw = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:telStr]];
    [callPhoneWebVw loadRequest:request];
}

- (void)OtherProfileMessage
{

}

- (void)OtherProfileMail
{
    
}

- (void)OtherProfileChat
{
    NSLog(@"chat");
    if ([self showLoginAlert]) {
        return;
    }
    
    if ([self.contact.isreal isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户只接受短信" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    
//    TalkViewController *talk = [[[TalkViewController alloc] initWithNibName:@"TalkViewController" bundle:nil] autorelease];
//    talk.username = self.contact.username;
//    talk.fid = self.contact.userid;
//    talk.fAvatarUrl = self.contact.picturelinkurl;
//    NSLog(@"talk.fid %@", talk.fid);
//    [self.navigationController pushViewController:talk animated:YES];
}

#pragma mark - heade delegate

- (void)otherProfileHeaderComment
{
    if ([kAppDelegate.userId isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录修改备注" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [[alert textFieldAtIndex:0] setPlaceholder:@"备注"];
        alert.tag = loginAlert;
        [alert show];
        [alert release];
        [self.view endEditing:YES];
        return;
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改备注" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.delegate = self;
    textField.placeholder = @"备注";
    textField.clearsOnBeginEditing = YES;
    alert.tag = commentAlert;
    [alert show];
    [alert release];
}

//- (void)otherProfileModifyImage
//{
//    
//}

#pragma mark - alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == loginAlert) {
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            [loginVC release];
        }
    }else if (alertView.tag == commentAlert){
        if (buttonIndex == 1) {
            NSString *comment = [[alertView textFieldAtIndex:0] text];
            if ([comment isValid]) {
                NSString *name = [NSString stringWithFormat:@"%@(%@)", self.contact.username, comment];
                self.contact.remark = comment;
                self.tableHeader.nameLabel.text = name;
                DB_SAVE();
            }
        }
    }
    
}

#pragma mark - blacklist

- (void)addBlacklist
{
    NSDictionary *para = @{@"path": @"addBlackUser.json",
                           @"userid": kAppDelegate.userId,
                           @"blackuserid": self.contact.userid};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            DLog(@"add black %@", json);
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)delBlacklist
{
    NSDictionary *para = @{@"path": @"delBlackUser.json",
                           @"userid": kAppDelegate.userId,
                           @"blackuserid": self.contact.userid};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            DLog(@"del black %@", json);
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.contact.remark isValid]) {
        textField.text = self.contact.remark;
    }
    
    textField.returnKeyType = UIReturnKeyDone;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"text field edit end");
    
    
    NSString *destid = self.contact.userid;
    NSString *userid = kAppDelegate.userId;
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"userid",
                              destid, @"destid",
                              textField.text, @"remark",
                              @"changeuserremark.json", @"path", nil];
    
    //        NSLog(@"comment para dict: %@", paraDict);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[json objectForKey:@"returnCode"] longValue] == 0) {
            hud.labelText = @"修改成功";
            [hud hide:YES afterDelay:.3];
            
            if (![textField.text isValid]) {
                self.contact.remark = @"";
            }
            else{
                self.contact.remark = textField.text;
                NSString *remark = [NSString stringWithFormat:@"(%@)", self.contact.remark];
                textField.text = remark;
            }
            self.contact.loginid = [kAppDelegate userId];
            
            DB_SAVE();
        }
        else{
            [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - footer delegate

- (void)otherProfileAddFriend
{
    if ([self showLoginAlert]) {
        return;
    }
    
    if (!self.isFriend) {
        NSLog(@"添加好友");
        
        //添加关注, addZsAttentionUser.json, userid, attentionid provinceid cityid
        NSString *attentionid =  self.contact.userid;
        NSString *userid = [kAppDelegate userId];
        NSString *cityid = [PersistenceHelper dataForKey:kCityId];
        NSString *provinceid = [[Utility getCityIdByCityName:[PersistenceHelper dataForKey:kCityName]] proId];
        
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:attentionid, @"attentionid",
                                  userid, @"userid",
                                  cityid, @"cityid",
                                  provinceid, @"provinceid",
                                  @"addZsAttentionUser.json", @"path", nil];
        
        //        NSLog(@"para Dict: %@", paraDict);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"添加好友";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            
            if (RETURNCODE_ISVALID(json)) {
                
                self.isFriend = YES;
                [self.tableFooter.addFriendButton setTitle:@"删除好友" forState:UIControlStateNormal];
                
                [self updateIsFriend:self.isFriend];
                
            }
            else{
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
    else{
        NSLog(@"删除好友");
        
        //添加关注, delZsAttentionUser.json, userid, attentionid provinceid cityid
        
        NSString *attentionid = self.contact.userid;
        NSString *userid = [kAppDelegate userId];
        NSString *cityid = [PersistenceHelper dataForKey:kCityId];
        NSString *provinceid = [PersistenceHelper dataForKey:kProvinceId];
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:attentionid, @"attentionid",
                                  userid, @"userid",
                                  cityid, @"cityid",
                                  provinceid, @"provinceid",
                                  @"delZsAttentionUser.json", @"path", nil];
        
        //        NSLog(@"para Dict: %@", paraDict);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"删除好友";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            if (RETURNCODE_ISVALID(json)) {
                
                self.isFriend = NO;
                [self.tableFooter.addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
                [self updateIsFriend:self.isFriend];
            }
            else{
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
}

- (void)updateIsFriend:(BOOL)isFriend
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userid == %@ AND loginid == %@ AND cityid == %@", self.contact.userid, [kAppDelegate userId], [PersistenceHelper dataForKey:kCityId]];
    FriendContact *friendContact = [FriendContact findFirstWithPredicate:pred];
    if (friendContact == nil) {
        friendContact = [FriendContact createEntity];
        friendContact.autograph = self.contact.autograph;
        friendContact.cityid = [PersistenceHelper dataForKey:kCityId];
        friendContact.col1 = self.contact.col1;
        friendContact.col2 = self.contact.col2;
        friendContact.col3 = self.contact.col3;
        friendContact.invagency = self.contact.invagency;
        friendContact.loginid = kAppDelegate.userId;
        friendContact.mailbox = self.contact.mailbox;
        friendContact.picturelinkurl = self.contact.picturelinkurl;
        //        friendContact.remark = self.commentTextField.text;
        friendContact.sectionkey = self.contact.sectionkey;
        friendContact.tel = self.contact.tel;
        friendContact.userid = self.contact.userid;
        friendContact.username = self.contact.username;
        friendContact.username_p = self.contact.username_p;
    }
    
    if (self.isFriend) {
        friendContact.type = @"1";
    }
    else
    {
        friendContact.type = @"0";
    }
    
    DB_SAVE();
    
}

- (void)otherProfileAddBlack
{
    if (self.isBlack) {
        NSDictionary *para = @{@"path": @"delBlackUser.json",
                               @"userid": kAppDelegate.userId,
                               @"blackuserid": self.contact.userid};
        
        [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
        [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            if (RETURNCODE_ISVALID(json)) {
                DLog(@"del black %@", json);
                self.isBlack = NO;
                [self.tableFooter.addBlackButton setTitle:@"加入黑名单" forState:UIControlStateNormal];
            }
            else{
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
    else{
        NSDictionary *para = @{@"path": @"addBlackUser.json",
                               @"userid": kAppDelegate.userId,
                               @"blackuserid": self.contact.userid};
        
        [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
        [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            if (RETURNCODE_ISVALID(json)) {
                self.isBlack = YES;
                [self.tableFooter.addBlackButton setTitle:@"从黑名单中移除" forState:UIControlStateNormal];
                DLog(@"add black %@", json);
            }
            else{
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
}

@end
