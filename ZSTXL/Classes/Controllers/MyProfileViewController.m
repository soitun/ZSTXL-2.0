//
//  MyProfileViewControllerViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MyProfileViewController.h"
#import "HomePageCell.h"
#import "UserDetail.h"
#import "Pharmacology.h"
#import "CityInfo.h"
#import "CustomBadge.h"
#import "SettingViewController.h"
#import "MailBoxViewController.h"
#import "LoginViewController.h"
#import "FinanceInfoViewController.h"


@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.view.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-49);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self showBasicInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的主页";
    self.leftArray_1 = @[@"招商代理：", @"常驻地区：", @"类别偏好：", @"财务信息："];
    self.leftArray_2 = @[@"我的招商代理信息", @"好友的招商代理信息"];
    [self initTableSelector];
    
    self.scrollView.contentSize = CGSizeMake(320, 520);
    self.navigationController.delegate = self;
    [self autoLogin];
    
    [self getMyInfoFromDB];
    [self showBasicInfo];
    [self initNavBar];
    [self initHeadIcon];
}

- (void)dealloc {
    [_nameLabel release];
    [_useridLabel release];
    [_telLabel release];
    [_gradeLabel release];
    [_xunImage release];
    [_xunVImage release];
    [_xunBImage release];
    [_tableView_1 release];
    [_tableView_2 release];
    [_headIcon release];
    [_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setUseridLabel:nil];
    [self setTelLabel:nil];
    [self setGradeLabel:nil];
    [self setXunImage:nil];
    [self setXunVImage:nil];
    [self setXunBImage:nil];
    [self setTableView_1:nil];
    [self setTableView_2:nil];
    [self setHeadIcon:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

#pragma mark - navigation delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:NSClassFromString(@"MyProfileViewController")]) {
        [kAppDelegate.tabController hidesTabBar:NO animated:YES];
    }
    else{
        [kAppDelegate.tabController hidesTabBar:YES animated:YES];
    }
}

#pragma mark - auto login

- (void)autoLogin
{
    if (![[PersistenceHelper dataForKey:kUserId] isValid]) {
        LoginViewController *loginVC = [[[LoginViewController alloc] init] autorelease];
        CustomNavigationController *nav = [[[CustomNavigationController alloc] initWithRootViewController:loginVC] autorelease];
        [self.navigationController presentModalViewController:nav animated:YES];
    }
}

- (void)initHeadIcon
{
    self.headIcon.layer.cornerRadius = 8;
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyHeadIcon)];
    [self.headIcon addGestureRecognizer:tap];
}

- (void)modifyHeadIcon
{
    NSLog(@"更换头像");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)getMyInfoFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
    self.myInfo = [MyInfo findFirstWithPredicate:pred];
    if (self.myInfo == nil) {
        [self getMyInfoFromNet];
    }
    else{
        [self showBasicInfo];
    }
}

- (void)getMyInfoFromNet
{
    //paradict getMypageDetail.json userid
    NSString *userid = [kAppDelegate userId];
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"userid", @"getMypageDetail.json", @"path", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取个人信息";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            DLog(@"my info json %@", json);
            
            NSDictionary *dict = [json objectForKey:@"UserDetail"];
            UserDetail *userDetail = [UserDetail createEntity];
            self.myInfo = [MyInfo createEntity];
            self.myInfo.userDetail = userDetail;
            self.myInfo.account = [json objForKey:@"Account"];
            self.myInfo.unreadCount = [json objForKey:@"UnreadCount"];
            self.myInfo.unreadSMSCount = [json objForKey:@"UnreadSMSCount"];
            self.myInfo.userDetail.username = [dict objForKey:@"username"];
            self.myInfo.userDetail.tel = [dict objForKey:@"tel"];
            self.myInfo.userDetail.mailbox = [dict objForKey:@"mailbox"];
            
            self.nameLabel.text = self.myInfo.userDetail.username;
            self.telLabel.text = self.myInfo.userDetail.tel;
            
            //            id: 20086,
            //        username: "liuyue",
            //        tel: "13800000005",
            //        mailbox: "1234@qq.com",
            //        picturelinkurl: "",
            //        invagency: 3,
            //        autograph: "",
            //        col1: "20086@boramail.com",
            //        col2: "",
            //        col3: ""
            
            //            NSLog(@"my info %@", dict);
            
            self.myInfo.userDetail.userid = [[dict objForKey:@"id"] stringValue];
            self.myInfo.userDetail.picturelinkurl = [dict objForKey:@"picturelinkurl"];
            self.myInfo.userDetail.invagency = [[dict objForKey:@"invagency"] stringValue];
            self.myInfo.userDetail.autograph = [dict objForKey:@"autograph"];
            self.myInfo.userDetail.col1 = [dict objForKey:@"col1"];
            self.myInfo.userDetail.col2 = [dict objForKey:@"col2"];
            self.myInfo.userDetail.col3 = [dict objForKey:@"col3"];
            
            if (![self.myInfo.userDetail.col2 isEqualToString:@"1"]) {
                self.xunVImage.hidden = YES;
            }
            
            DLog(@"myinfo %@", self.myInfo);
            DB_SAVE();
            
            [self showBasicInfo];
            
            
//            //取得未读消息
//            int unreadCount = [[json objForKey:@"UnreadCount"] intValue];
//            NSLog(@"unreadcount: %d", unreadCount);
//            if (unreadCount > 0) {
//                
//                CustomBadge *badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", unreadCount]
//                                                        withStringColor:[UIColor whiteColor]
//                                                         withInsetColor:[UIColor redColor]
//                                                         withBadgeFrame:YES
//                                                    withBadgeFrameColor:[UIColor whiteColor]
//                                                              withScale:1.0
//                                                            withShining:YES];
//                
//                CGRect badgeFrame = badge.frame;
//                badgeFrame.origin.y = -5.f;
//                badgeFrame.origin.x = self.chatButton.frame.size.width - badgeFrame.size.width + 2.f;
//                badge.frame = badgeFrame;
//                
//                [self.chatButton addSubview:badge];
//                [self.view bringSubviewToFront:self.chatButton];
//                
//            }
//            
//            int UnreadSMSCount = [[json objForKey:@"UnreadSMSCount"] intValue];
//            if (UnreadSMSCount > 0) {
//                CustomBadge *badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", UnreadSMSCount]
//                                                        withStringColor:[UIColor whiteColor]
//                                                         withInsetColor:[UIColor redColor]
//                                                         withBadgeFrame:YES
//                                                    withBadgeFrameColor:[UIColor whiteColor]
//                                                              withScale:1.0
//                                                            withShining:YES];
//                
//                CGRect badgeFrame = badge.frame;
//                badgeFrame.origin.y = -5.f;
//                badgeFrame.origin.x = self.chatButton.frame.size.width - badgeFrame.size.width + 2.f;
//                badge.frame = badgeFrame;
//                
//                [self.messageButton addSubview:badge];
//                [self.view bringSubviewToFront:self.chatButton];
//            }
//            
//            [self.myInfo removeAreaList:self.myInfo.areaList];
//            NSArray *residentArray = [json objectForKey:@"AreaList"];
//            NSLog(@"residentArray: %@", residentArray);
//            [residentArray enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
//                if (idx>1) {
//                    *stop = YES;
//                }else{
//                    CityInfo *city = [CityInfo  createEntity];
//                    [city setValuesForKeysWithDictionary:cityDict];
//                    [self.myInfo addAreaListObject:city];
//                }
//            }];
//            
//            
//            [self.myInfo removePharList:self.myInfo.pharList];
//            NSArray *preferArray = [json objectForKey:@"PreferList"];
//            //            NSMutableSet *pharSet = [[[NSMutableSet alloc] init] autorelease];
//            [preferArray enumerateObjectsUsingBlock:^(NSDictionary *preferDict, NSUInteger idx, BOOL *stop) {
//                Pharmacology *phar = [Pharmacology createEntity];
//                phar.content = [preferDict objForKey:@"prefername"];
//                phar.pharid  = [[preferDict objForKey:@"id"] stringValue];
//                [self.myInfo addPharListObject:phar];
//                //                [pharSet addObject:phar];
//            }];
//            
//            DB_SAVE();
//            
//            [self showBasicInfo];
//            //            [self showMessageBadge];
            [self.tableView_1 reloadData];
            
        } else{
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [self.tableView_1 reloadData];
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - show my info

- (void)showBasicInfo
{
    self.nameLabel.text = self.myInfo.userDetail.username;
    self.telLabel.text = self.myInfo.userDetail.tel;
    
    UIImage *headIconImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:self.myInfo.userDetail.headiconlocalurl]];
    if (headIconImage != nil) {
        self.headIcon.image = headIconImage;
    }
    else{
        [self.headIcon setImageWithURL:[NSURL URLWithString:self.myInfo.userDetail.picturelinkurl] placeholderImage:[UIImage imageNamed:@"avatar"]];
    }
    
    self.useridLabel.text = kAppDelegate.userId;
}

#pragma mark - table view

- (void)initTableSelector
{
    NSArray *selectorNameArray_1 = @[@"chooseAngencyOrBusiness", @"addArea", @"addPhar", @"showExtra"];
    NSArray *selectorNameArray_2 = @[@"hisBusinessInfo", @"friendBusinessInfo"];
    
    self.selectorArray_1 = [[[NSMutableArray alloc] init] autorelease];
    [selectorNameArray_1 enumerateObjectsUsingBlock:^(NSString *selectorName, NSUInteger idx, BOOL *stop) {
        SEL sel = NSSelectorFromString(selectorName);
        [self.selectorArray_1 addObject:[NSValue valueWithPointer:sel]];
    }];
    
    self.selectorArray_2 = [[[NSMutableArray alloc] init] autorelease];
    [selectorNameArray_2 enumerateObjectsUsingBlock:^(NSString *selectorName, NSUInteger idx, BOOL *stop) {
        SEL sel = NSSelectorFromString(selectorName);
        [self.selectorArray_2 addObject:[NSValue valueWithPointer:sel]];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView_1) {
        return self.leftArray_1.count;
    }
    else{
        return self.leftArray_2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomePageCell" owner:self options:nil] lastObject];
    
    if (tableView == self.tableView_1) {
        switch (indexPath.row) {
            case 0:{
                int inva = self.myInfo.userDetail.invagency.intValue;
                NSString *strInva = nil;
                switch (inva) {
                    case 1:
                        strInva = @"招商";
                        break;
                    case 2:
                        strInva = @"代理";
                        break;
                    case 3:
                        strInva = @"招商、代理";
                        break;
                    default:
                        break;
                }
                cell.detailLabel.text = strInva;
            }
                break;
                
            case 1:{
                NSMutableString *area = [NSMutableString string];
                for (CityInfo *cityInfo in self.myInfo.areaList)
                {
                    [area appendFormat:@"%@、", cityInfo.cityname];
                }
                
                if ([area isValid])
                {
                    area = [NSMutableString stringWithString:[area substringToIndex:area.length-1]];
                }
                
                cell.detailLabel.text = area;
            }
                break;
                
            case 2:{
                NSMutableString *pharList = [NSMutableString string];
                for (Pharmacology *phar in self.myInfo.pharList)
                {
                    [pharList appendFormat:@"%@、", phar.content];
                }
                
                if ([pharList isValid])
                {
                    pharList = [NSMutableString stringWithString:[pharList substringToIndex:pharList.length-1]];
                }
                
                cell.detailLabel.text = pharList;
            }
                break;
                
            case 3:
                cell.detailLabel.text = [NSString stringWithFormat:@"%d 条", self.myInfo.account.intValue];
                break;
                
            default:
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = [self.leftArray_1 objectAtIndex:indexPath.row];
        
        if (indexPath.row == self.leftArray_1.count-1) {
            cell.separatorImage.hidden = YES;
        }
    }
    else if (tableView == self.tableView_2){
        CGRect frame = cell.nameLabel.frame;
        frame.size.width = 240;
        cell.nameLabel.frame = frame;
        cell.detailLabel.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.nameLabel.text = [self.leftArray_2 objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == self.leftArray_2.count-1) {
            cell.separatorImage.hidden = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_1) {
        SEL sel = [[self.selectorArray_1 objectAtIndex:indexPath.row] pointerValue];
        [self performSelector:sel];
    }
    else if (tableView == self.tableView_2){
        SEL sel = [[self.selectorArray_2 objectAtIndex:indexPath.row] pointerValue];
        [self performSelector:sel];
    }
}

#pragma mark - table selector

//@"chooseAngencyOrBusiness", @"`", @"addPhar:", @"showExtra"

- (void)chooseAngencyOrBusiness
{
    DLog(@"chooseAngencyOrBusiness")
}

- (void)addArea
{
    DLog(@"addArea");
    SelectCityViewController *selectCityVC = [[[SelectCityViewController alloc] init] autorelease];
    selectCityVC.delegate = self;
    selectCityVC.allowMultiselect = YES;
    [self.navigationController pushViewController:selectCityVC animated:YES];
}

- (void)addPhar
{
    DLog(@"addPhar");
    SelectPharViewController *selectPharVC = [[[SelectPharViewController alloc] init] autorelease];
    selectPharVC.delegate = self;
    [self.navigationController pushViewController:selectPharVC animated:YES];
}

- (void)showExtra
{
    DLog(@"showExtra");
    FinanceInfoViewController *financeInfoVC = [[[FinanceInfoViewController alloc] init] autorelease];
    [self.navigationController pushViewController:financeInfoVC animated:YES];
}

- (void)hisBusinessInfo
{
    DLog(@"hisBusinessInfo");
}

- (void)friendBusinessInfo
{
    DLog(@"friendBusinessInfo");
}

#pragma mark - select city delegate

- (void)SelectCityFinished:(NSArray *)array
{
    DLog(@"array %@", array);
    
    [self.myInfo.areaList enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [self.myInfo removeAreaListObject:obj];
    }];
    
    if (array.count == 0) {
        [self makeDefaultCity];
    }

    for (NSDictionary *city in array) {
        CityInfo *cityInfo = [CityInfo createEntity];
        cityInfo.cityname = [city objForKey:@"cityname"];
        cityInfo.cityid = [city objForKey:@"cityid"];
        cityInfo.provinceid = [city objForKey:@"provinceid"];
        [self.myInfo addAreaListObject:cityInfo];
    }
    
    DB_SAVE();
    [self.tableView_1 reloadData];
}

- (void)makeDefaultCity
{
    NSString *defaultCity = kAppDelegate.theNewCity;
    NSString *provinceId = [[Utility getCityIdByCityName:defaultCity] proId];
    NSString *cityId = [[Utility getCityIdByCityName:defaultCity] cityId];
    
    CityInfo *city = [CityInfo createEntity];
    city.cityid = cityId;
    city.provinceid = provinceId;
    city.cityname = defaultCity;
    [self.myInfo addAreaListObject:city];
    DB_SAVE();
}

#pragma mark - select phar delegate

- (void)selectPharFinished:(NSArray *)array
{
    if (array.count == 0) {
        return;
    }
    else{
        //pharid
        
        NSMutableString *preferid = [[[NSMutableString alloc] init] autorelease];
        for (NSDictionary *dict in array) {
            [preferid appendFormat:@"%@,", [dict objForKey:@"pharid"]];
        }
        if ([preferid isValid]) {
            preferid = [NSMutableString stringWithString:[preferid substringToIndex:preferid.length-1]];
        }
        
        NSSet *pharlist = self.myInfo.pharList;
        [self.myInfo removePharList:pharlist];

        
        NSDictionary *paraDict = @{@"path": @"changeprefer.json",
                               @"preferid": preferid,
                               @"userid": [PersistenceHelper dataForKey:kUserId]};
        
        
        [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                
                for (NSDictionary *dict in array) {
                    Pharmacology *phar = [Pharmacology createEntity];
                    phar.pharid = [dict objForKey:@"pharid"];
                    phar.content = [dict objForKey:@"content"];
                    [self.myInfo addPharListObject:phar];
                }
                
                DB_SAVE();
                [self.tableView_1 reloadData];
                
            }
            else{

                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
        
    }
}


#pragma mark - contact

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (IBAction)message:(UIButton *)sender
{
    
}

- (IBAction)mail:(UIButton *)sender
{
    MailBoxViewController *mailBoxVC = [[[MailBoxViewController alloc] init] autorelease];
    [self.navigationController pushViewController:mailBoxVC animated:YES];
}

- (IBAction)chat:(UIButton *)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - nav bar

- (void)initNavBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)setting:(UIButton *)sender
{
    SettingViewController *setVC = [[[SettingViewController alloc] init] autorelease];
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex; %d", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.showsCameraControls = YES;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
            break;
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
            break;
        case 2:
            NSLog(@"设置头像取消");
            break;
        default:
            break;
    }
}

#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.headIcon.image=[info valueForKey:UIImagePickerControllerEditedImage];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"上传头像";
    
    UIImage *smallImage = [self.headIcon.image scaleToFillSize:CGSizeMake(180.f, 180.f)];
    //addAndUpdateUserPic.json image userid imageurl
    NSString *userid = self.myInfo.userDetail.userid;
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:@"addAndUpdateUserPic.json", @"path",
                              userid, @"userid",
                              self.userDetail.picturelinkurl, @"imageurl", nil];
    
    NSLog(@"smallImage width: %f, height: %f", smallImage.size.width, smallImage.size.height);
    
    [DreamFactoryClient postWithParameters:paraDict image:smallImage success:^(id obj) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:@"上传成功" andImageName:nil];
        
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingFormat:@"/%@.png", self.myInfo.userDetail.username];
        
        self.myInfo.userDetail.headiconlocalurl = path;
        [Utility saveImage:smallImage toDiskWithName:path];
        
        DB_SAVE();
        
    } failure:^{
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:@"上传失败" andImageName:nil];
    }];
    
    [picker dismissModalViewControllerAnimated:YES];
}

@end
