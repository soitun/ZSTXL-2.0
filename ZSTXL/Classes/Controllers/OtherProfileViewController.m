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
            NSLog(@"friend json data: %@", json);
            
            
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
        [self.addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
    }
    else{
        self.isFriend = YES;
        [self.addFriendButton setTitle:@"删除好友" forState:UIControlStateNormal];
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
    
}

- (void)addFriend:(UIButton *)sender
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
                [self.addFriendButton setTitle:@"删除好友" forState:UIControlStateNormal];
                
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
                [self.addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
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
    self.tableView.scrollEnabled = NO;
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
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    
    self.addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
    [self.addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addFriendButton setBackgroundImage:[UIImage imageNamed:@"addfriend_button"] forState:UIControlStateNormal];
    [self.addFriendButton setBackgroundImage:[UIImage imageNamed:@"addfriend_button_p"] forState:UIControlStateHighlighted];
    self.addFriendButton.frame = CGRectMake(15, 10, 289, 48);
    [self.addFriendButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.addFriendButton];
    
    [self.tableView setTableFooterView:footerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20.f;
    }else{
        return 10.f;
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
    
    
    TalkViewController *talk = [[[TalkViewController alloc] initWithNibName:@"TalkViewController" bundle:nil] autorelease];
    talk.username = self.contact.username;
    talk.fid = self.contact.userid;
    talk.fAvatarUrl = self.contact.picturelinkurl;
    NSLog(@"talk.fid %@", talk.fid);
    [self.navigationController pushViewController:talk animated:YES];
}

#pragma mark - heade delegate

- (void)otherProfileHeaderComment
{
    
}

- (void)otherProfileModifyImage
{
    
}

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

@end
