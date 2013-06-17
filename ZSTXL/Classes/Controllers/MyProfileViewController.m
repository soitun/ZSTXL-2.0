//
//  MyHomePageViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MyProfileViewController.h"
#import "HomePageCell.h"
#import "CustomCellBackgroundView.h"
#import "MyInfo.h"
#import "UserDetail.h"
#import "CityInfo.h"
#import "Pharmacology.h"
#import "StarNewsInfo.h"

#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MailBoxViewController.h"
#import "FinanceInfoViewController.h"
#import "StarInfoViewController.h"
#import "AddMeViewController.h"
#import "BlacklistViewController.h"
#import "FriendInvAgencyViewController.h"
#import "MyInvAgencyViewController.h"

#import "SBTableAlert.h"
#import "ZDCell.h"



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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = bgGreyColor;
    self.title = @"我的主页";
    self.navigationController.delegate = self;
    
    self.zdNameArray = [[[NSMutableArray alloc] initWithObjects:@"招商", @"代理", nil] autorelease];
    self.zdDict = [[[NSMutableDictionary alloc] init] autorelease];
    [self.zdNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.zdDict setObject:[NSNumber numberWithInt:0] forKey:obj];
    }];
    self.zdValue = [NSNumber numberWithInt:0];
    
    
    [self initNavBar];
    [self initTableData];
    [self initTableView];
    [self initTableHeader];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetNavigationBar {
    if (self.navigationController.navigationBar.frame.origin.y != 0) {
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![kAppDelegate.userId isEqualToString:@"0"]) {
        [self getMyInfoFromDB];
        [self showHeaderInfo];
        [self getMyInfoFromNet];
    }
    else{
        LoginViewController *loginVC = [[[LoginViewController alloc] init] autorelease];
        loginVC.delegate = self;
        CustomNavigationController *nav = [[[CustomNavigationController alloc] initWithRootViewController:loginVC] autorelease];
        [self.navigationController presentModalViewController:nav animated:YES];
    }
}

#pragma mark - nav bar

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:NSClassFromString(@"MyProfileViewController")]) {
        [kAppDelegate.tabController hidesTabBar:NO animated:YES];
    }
    else{
        [kAppDelegate.tabController hidesTabBar:YES animated:YES];
    }
}

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

#pragma mark - header info

- (void)showHeaderInfo
{
    self.tableHeader.nameLabel.text = self.myInfo.userDetail.username;
    self.tableHeader.userIdLabel.text = self.myInfo.userDetail.userid;
    self.tableHeader.telLabel.text = self.myInfo.userDetail.tel;

    //save avatar
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.myInfo.userDetail.picturelinkurl]];
    [self.tableHeader.headIcon setImageWithURLRequest:urlRequest placeholderImage:[UIImage imageNamed:@"home_icon"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.tableHeader.headIcon.image = image;
        NSString *localUrl = [[self.myInfo.userDetail.picturelinkurl componentsSeparatedByString:@"/"] lastObject];
        [Utility saveImage:image toDiskWithName:localUrl];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        DLog(@"error %@", error);
    }];
    
    
    if ([self.myInfo.userDetail.col2 isEqualToString:@"1"]) {
        self.tableHeader.xunVImage.hidden = NO;
    }else{
        self.tableHeader.xunVImage.hidden = YES;
    }
    
    if ([self.myInfo.userDetail.ismember isEqualToString:@"1"]) {
        self.tableHeader.xunImage.hidden = NO;
    }
    else{
        self.tableHeader.xunImage.hidden = YES;
    }
}

- (void)myProfileModifyImage
{
    NSLog(@"更换头像");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
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
    self.tableHeader.headIcon.image=[info valueForKey:UIImagePickerControllerEditedImage];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"上传头像";
    
    UIImage *smallImage = [self.tableHeader.headIcon.image scaleToFillSize:CGSizeMake(180.f, 180.f)];
    //addAndUpdateUserPic.json image userid imageurl
    NSString *userid = self.myInfo.userDetail.userid;
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:@"addAndUpdateUserPic.json", @"path",
                              userid, @"userid",
                              self.myInfo.userDetail.picturelinkurl, @"imageurl", nil];
    
    DLog(@"smallImage width: %f, height: %f", smallImage.size.width, smallImage.size.height);
    
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

#pragma mark - get my info

- (void)getMyInfoFromDB
{
    self.myInfo = [Utility getMyInfo];
}

- (void)getMyInfoFromNet
{
    //paradict getMypageDetail.json userid
    
    NSDictionary *para = @{@"path": @"getMypageDetail.json", @"userid": @"109976"};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取个人信息";
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        if (RETURNCODE_ISVALID(json)) {
//            DLog(@"my info json %@", json);
            [self updateMyInfo:json];
            [self showHeaderInfo];
            [self.tableView reloadData];
//            DLog(@"myinfo %@", self.myInfo);

        } else{
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)updateMyInfo:(NSDictionary *)json
{
    NSDictionary *dict = [json objectForKey:@"UserDetail"];
    UserDetail *userDetail = [UserDetail createEntity];
    self.myInfo = [MyInfo createEntity];
    self.myInfo.userDetail = userDetail;
    self.myInfo.account = [[json objForKey:@"Account"] stringValue];
    self.myInfo.unreadCount = [[json objForKey:@"UnreadCount"] stringValue];
    self.myInfo.unreadSMSCount = [[json objForKey:@"UnreadSMSCount"] stringValue];
    self.myInfo.userDetail.username = [dict objForKey:@"username"];
    self.myInfo.userDetail.tel = [dict objForKey:@"tel"];
    self.myInfo.userDetail.mailbox = [dict objForKey:@"mailbox"];
    self.myInfo.userDetail.userid = [[dict objForKey:@"id"] stringValue];
    self.myInfo.userDetail.picturelinkurl = [dict objForKey:@"picturelinkurl"];
    self.myInfo.userDetail.invagency = [[dict objForKey:@"invagency"] stringValue];
    self.myInfo.userDetail.autograph = [dict objForKey:@"autograph"];
    self.myInfo.userDetail.col1 = [dict objForKey:@"col1"];
    self.myInfo.userDetail.col2 = [dict objForKey:@"col2"];
    self.myInfo.userDetail.col3 = [dict objForKey:@"col3"];
    
    [self.myInfo removeAreaList:self.myInfo.areaList];
    NSArray *areaArray = [json objForKey:@"AreaList"];
    for (NSDictionary *cityDict in  areaArray) {
        CityInfo *city = [CityInfo createEntity];
        city.cityname = [cityDict objForKey:@"cityname"];
        city.cityid = [cityDict objForKey:@"cityid"];
        city.provinceid = [cityDict objForKey:@"provinceid"];
        [self.myInfo addAreaListObject:city];
    }
    
    [self.myInfo removePharList:self.myInfo.pharList];
    NSArray *pharArray = [json objForKey:@"PreferList"];
    for (NSDictionary *pharDict in pharArray) {
        Pharmacology *phar = [Pharmacology createEntity];
        phar.pharid = [[pharDict objForKey:@"id"] stringValue];
        phar.content = [pharDict objForKey:@"prefername"];
        [self.myInfo addPharListObject:phar];
    }
    
    //save image
    
//    NSString *picUrl = [[self.myInfo.userDetail.picturelinkurl componentsSeparatedByString:@"/"] lastObject];
    
    DB_SAVE();
}


#pragma mark - init Table

- (void)initTableData
{
    self.titleArray = @[@[@"招商代理：", @"常驻地区：", @"类别偏好：", @"财务信息"], @[@"我的招商代理信息", @"好友的招商代理信息"]];
    self.selectorArray = @[@[@"invAgency", @"area", @"pharmacology", @"finance"], @[@"myInvInfo", @"friendInvInfo"]];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = kCellBorderColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)initTableHeader
{
    self.tableHeader = [[[NSBundle mainBundle] loadNibNamed:@"MyProfileHeader" owner:self options:nil] lastObject];
    self.tableHeader.delegate = self;
    self.tableView.tableHeaderView = self.tableHeader;
}

#pragma mark - tableview datasource, delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;;
    switch (section) {
        case 0:
            number = 1;
            break;
        case 1:
            number = 4;
            break;
        case 2:
            number = 2;
            break;
        default:
            break;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    if (indexPath.section == 0) {
        height = 47.5f;     //.5 !!!!!
    }else{
        height = 44.f;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *conactCellId = @"MyProfileContactCell";
    static NSString *normalCellId = @"HomePageCell";
    
    if (indexPath.section == 0) {
        MyProfileContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:conactCellId];
        if (contactCell == nil) {
            contactCell = [[[NSBundle mainBundle] loadNibNamed:@"MyProfileContactCell" owner:self options:nil] lastObject];
        }
        contactCell.delegate = self;
        [Utility groupTableView:tableView addBgViewForCell:contactCell withCellPos:CustomCellBackgroundViewPositionSingle];
        contactCell.accessoryType = UITableViewCellAccessoryNone;
        contactCell.messageBadgeValue = self.myInfo.unreadSMSCount;
        contactCell.messageBadgeValue = self.myInfo.unreadCount;
        contactCell.messageBadgeValue = self.myInfo.unreadMailCount;
        contactCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [contactCell setNeedsDisplay];
        
        return contactCell;
    }else{
        HomePageCell *normalCell = [tableView dequeueReusableCellWithIdentifier:normalCellId];
        if (normalCell == nil) {
            normalCell = [[[NSBundle mainBundle] loadNibNamed:@"HomePageCell" owner:self options:nil] lastObject];
        }
        
        [self configureCell:normalCell AtIndexPath:indexPath];
        return normalCell;
    }
    return nil;
}

- (void)configureCell:(HomePageCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    CustomCellBackgroundViewPosition pos;
    if (indexPath.section == 0) {
        pos = CustomCellBackgroundViewPositionSingle;
    }
    else{
        if (indexPath.row == 0) {
            pos = CustomCellBackgroundViewPositionTop;
        }else if (indexPath.row == [[self.titleArray objectAtIndex:indexPath.section-1] count]-1){
            pos = CustomCellBackgroundViewPositionBottom;
        }else{
            pos = CustomCellBackgroundViewPositionMiddle;
        }
    }
    [Utility groupTableView:self.tableView addBgViewForCell:cell withCellPos:pos];
    
    
    if (indexPath.section > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.nameLabel.text = [[self.titleArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        switch ([self.myInfo.userDetail.invagency intValue]) {
            case 1:
                self.zdName = @"招商";
                break;
            case 2:
                self.zdName = @"代理";
                break;
            case 3:
                self.zdName = @"招商/代理";
                break;
            default:
                break;
        }
        cell.detailLabel.text = self.zdName;
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        NSMutableString *areaName = [NSMutableString string];
        for (CityInfo *city in self.myInfo.areaList) {
            [areaName appendFormat:@"%@、", city.cityname];
        }
        if ([areaName isValid]) {
            cell.detailLabel.text = [areaName substringToIndex:areaName.length-1];
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        NSMutableString *prefercontent = [NSMutableString string];
        for (Pharmacology *phar in self.myInfo.pharList) {
            [prefercontent appendFormat:@"%@、",phar.content];
        }
        if ([prefercontent isValid]) {
            cell.detailLabel.text = [prefercontent substringToIndex:prefercontent.length-1];
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 3){
        cell.detailLabel.text = nil;
    }
    
    [cell setNeedsDisplay];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selName = [[self.selectorArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
    SEL sel = NSSelectorFromString(selName);
    [self performSelector:sel];
}

#pragma mark - table selector

- (void)invAgency
{
    SBTableAlert *tableAlert = [[SBTableAlert alloc] initWithTitle:@"请选择招商代理" cancelButtonTitle:@"确定" messageFormat:nil];
    [tableAlert setType:SBTableAlertTypeMultipleSelct];
    tableAlert.delegate = self;
    tableAlert.dataSource = self;
    [tableAlert show];
}

- (void)area
{
    DLog(@"addArea");
    SelectCityViewController *selectCityVC = [[[SelectCityViewController alloc] init] autorelease];
    selectCityVC.delegate = self;
    selectCityVC.allowMultiselect = YES;
    [self.navigationController pushViewController:selectCityVC animated:YES];
}

- (void)pharmacology
{
    DLog(@"addPhar");
    SelectPharViewController *selectPharVC = [[[SelectPharViewController alloc] init] autorelease];
    selectPharVC.delegate = self;
    [self.navigationController pushViewController:selectPharVC animated:YES];
}

- (void)finance
{
    DLog(@"showExtra");
    FinanceInfoViewController *financeInfoVC = [[[FinanceInfoViewController alloc] init] autorelease];
    [self.navigationController pushViewController:financeInfoVC animated:YES];
}

- (void)myInvInfo
{
    MyInvAgencyViewController *myInvAgencyVC = [[[MyInvAgencyViewController alloc] init] autorelease];
    [self.navigationController pushViewController:myInvAgencyVC animated:YES];
}

- (void)friendInvInfo
{
    FriendInvAgencyViewController *friendInvAgencyVC = [[[FriendInvAgencyViewController alloc] init] autorelease];
    [self.navigationController pushViewController:friendInvAgencyVC animated:YES];
}

#pragma mark - contact cell delegate

- (void)myProfileMessage
{
    
}

- (void)myProfileMail
{
    MailBoxViewController *mailBoxVC = [[[MailBoxViewController alloc] init] autorelease];
    [self.navigationController pushViewController:mailBoxVC animated:YES];
}

- (void)myProfileChat
{
    
}

#pragma mark - contact header delegate

- (void)myProfileAttent
{
    AddMeViewController *addMeVC = [[[AddMeViewController alloc] init] autorelease];
    [self.navigationController pushViewController:addMeVC animated:YES];
}

- (void)myProfileStar
{
    NSArray *array = [StarNewsInfo findAll];
    StarInfoViewController *starNewsVC = [[[StarInfoViewController alloc] init] autorelease];
    starNewsVC.dataSourceArray = array;
    [self.navigationController pushViewController:starNewsVC animated:YES];
}

- (void)myProfileBlacklist
{
    BlacklistViewController *blacklistVC = [[[BlacklistViewController alloc] init] autorelease];
    [self.navigationController pushViewController:blacklistVC animated:YES];
}

#pragma mark - select city delegate

- (void)SelectCityFinished:(NSArray *)array
{
    DLog(@"array %@", array);
    
    [self.myInfo removeAreaList:self.myInfo.areaList];
    
    if (array.count == 0) {
        return;
    }
    
    NSMutableString *tmp = [NSMutableString string];
    NSString *cityId = nil;
    for (NSDictionary *city in array) {
        [tmp appendFormat:@"%@:%@,", [city objForKey:@"provinceid"], [city objForKey:@"cityid"]];
    }
    
    if ([tmp isValid]) {
        cityId = [tmp substringToIndex:tmp.length-1];
    }
    
    NSDictionary *para = @{@"path": @"/=changezsarea.json",
                           @"provcityid": cityId,
                           @"userid": kAppDelegate.userId};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            for (NSDictionary *city in array) {
                CityInfo *cityInfo = [CityInfo createEntity];
                cityInfo.cityname = [city objForKey:@"cityname"];
                cityInfo.cityid = [city objForKey:@"cityid"];
                cityInfo.provinceid = [city objForKey:@"provinceid"];
                [self.myInfo addAreaListObject:cityInfo];
            }
            
            DB_SAVE();
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
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

- (void)updateChangedCity
{
    
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
                [self.tableView reloadData];
                
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

#pragma mark - login delegate

- (void)loginFinished
{
    [self showHeaderInfo];
    [self.tableView reloadData];
}

#pragma mark - table alert data source
- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert
{
    return 1;
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section
{
    return self.zdNameArray.count;
}

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ZDCell" owner:self options:nil] lastObject];
    cell.nameLabel.text = [self.zdNameArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDCell *cell = (ZDCell *)[tableAlert.tableView cellForRowAtIndexPath:indexPath];
    NSString *zdString = [self.zdNameArray objectAtIndex:indexPath.row];
    if (![[self.zdDict objectForKey:zdString] intValue] == 0) {
        [self.zdDict setObject:[NSNumber numberWithInt:0] forKey:zdString];
        cell.selectImage.image = [UIImage imageNamed:@"login_noselect.png"];
    }
    else{
        [self.zdDict setObject:[NSNumber numberWithInt:indexPath.row+1] forKey:zdString];
        cell.selectImage.image = [UIImage imageNamed:@"login_select.png"];
    }
}

- (CGFloat)tableAlert:(SBTableAlert *)tableAlert heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (void)tableAlert:(SBTableAlert *)tableAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __block int zdValueTmp = 0;
    [self.zdDict enumerateKeysAndObjectsUsingBlock:^(id key, NSNumber *num, BOOL *stop) {
        zdValueTmp += num.intValue;
    }];
    self.zdValue = [NSNumber numberWithInt:zdValueTmp];
    switch (zdValueTmp) {
        case 0:
            self.zdName = @"";
            break;
        case 1:
            self.zdName = @"招商";
            break;
        case 2:
            self.zdName = @"代理";
            break;
        case 3:
            self.zdName = @"招商/代理";
            break;
        default:
            break;
    }
    
    for (NSString *key in [self.zdDict allKeys]) {
        [self.zdDict setObject:[NSNumber numberWithInt:0] forKey:key];
    }
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    
    //修改招商代理
    NSDictionary *invAgencyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"changeInvAgency.json", @"path", self.zdValue, @"invagency", self.myInfo.userDetail.userid, @"userid", nil];
    
    
    [DreamFactoryClient getWithURLParameters:invAgencyDict success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
        
        
        if ([GET_RETURNCODE(json) isEqualToString:@"0"]) {
            NSLog(@"更改招商代理成功");
            self.myInfo.userDetail.invagency = [NSString stringWithFormat:@"%d", zdValueTmp];
            DB_SAVE();
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
    [tableAlert release];
}



@end
