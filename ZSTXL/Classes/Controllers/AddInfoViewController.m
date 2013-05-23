//
//  AddInfoViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-17.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "AddInfoViewController.h"
#import "ZhaoshangAndDailiViewController.h"
#import "SelectPharViewController.h"
#import "ProvinceViewController.h"
#import "AddInfoCell.h"
#import "CityInfo.h"
#import "Pharmacology.h"
#import "ZDCell.h"
#import "UserDetail.h"

#define CELL_ROW (3)
#define CELL_COLUM (2)

@interface AddInfoViewController ()

@end

@implementation AddInfoViewController

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
    
    self.title = @"完善信息";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    self.residentArray = [[[NSMutableArray alloc] init] autorelease];
    self.preferArray = [[[NSMutableArray alloc] init] autorelease];
    self.zdNameArray = [[[NSMutableArray alloc] initWithObjects:@"招商", @"代理", nil] autorelease];
    self.zdDict = [[[NSMutableDictionary alloc] init] autorelease];
    [self.zdNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.zdDict setObject:[NSNumber numberWithInt:0] forKey:obj];
    }];
    self.zdValue = [NSNumber numberWithInt:0];
    
    self.provcityid = [[[NSMutableString alloc] init] autorelease];
    self.preferid = [[[NSMutableString alloc] init] autorelease];
    
    NSMutableArray *array0 = [NSMutableArray arrayWithCapacity:4];
    for (int j = 0; j < CELL_ROW; j++) {
        [array0 addObject:@""];
    }
    [self.addInfo addObject:array0];
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:2];
    for (int j = 0; j < CELL_COLUM; j++) {
        [array1 addObject:@""];
    }
    [self.addInfo addObject:array1];
    
    ////////////////////init end
    
    
    self.view.backgroundColor = bgGreyColor;
    self.mTableView.backgroundColor = bgGreyColor;
    
    
    self.leftArray = [NSMutableArray arrayWithObjects:@"招商代理", @"常驻地区", @"类别偏好", nil];
    self.rightArray = [NSMutableArray arrayWithObjects:@"", @"", @"", nil];
    
    UIView *footView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake((320-300)/2.0, 5, 300, 44);
    [submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundImage:[UIImage imageByName:@"regist"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageByName:@"regist_p"] forState:UIControlStateHighlighted];
    [submitButton setTitle:@"完 成" forState:UIControlStateNormal];
    [footView addSubview:submitButton];
    self.mTableView.tableFooterView = footView;
    
    
    self.selectorNameArray = [NSArray arrayWithObjects:@"selectZhaoshangOrDaili", @"selectResident", @"selectCategory", nil];
    self.selectorArray = [[[NSMutableArray alloc] init] autorelease];
    [self.selectorNameArray enumerateObjectsUsingBlock:^(NSString *selectorName, NSUInteger idx, BOOL *stop) {
        SEL sel = NSSelectorFromString(selectorName);
        [self.selectorArray addObject:[NSValue valueWithPointer:sel]];
    }];
    
    [self getMyInfoFromDB];
}

- (void)getMyInfoFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
    self.myInfo = [MyInfo findFirstWithPredicate:pred];
}

- (void)submitAction
{
    
    if (self.finishSelectZD == NO) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择招商代理类型" andImageName:nil];
        return;
    }
    if (self.finishSelectCity == NO) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择常驻地区" andImageName:nil];
        return;
    }
    if (self.finishSelectPhar == NO) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择类别偏好" andImageName:nil];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(finishAddInfo)]) {
            [self.delegate performSelector:@selector(finishAddInfo)];
        }
    }];
}

- (NSString *)getUrlWithPara:(NSDictionary *)paraDict
{
    NSMutableString *baseUrl = [NSMutableString stringWithFormat:@"http://www.boracloud.com:9101/BLZTCloud/%@?", [paraDict objectForKey:@"path"]];
    [paraDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *paraPair = [NSString stringWithFormat:@"%@=%@&", key, obj];
        [baseUrl appendFormat:@"%@", paraPair];
    }];
    baseUrl = [NSMutableString stringWithString:[baseUrl substringToIndex:baseUrl.length-1]];
    return baseUrl;
}

- (void)selectZhaoshangOrDaili
{
    NSLog(@"选择招商代理");
    self.finishSelectZD = NO;
    SBTableAlert *tableAlert = [[SBTableAlert alloc] initWithTitle:@"请选择招商代理" cancelButtonTitle:@"确定" messageFormat:nil];
    [tableAlert setType:SBTableAlertTypeMultipleSelct];
    tableAlert.delegate = self;
    tableAlert.dataSource = self;
    [tableAlert show];
}

- (void)selectResident
{
    NSLog(@"选择常驻地区");
    self.finishSelectCity = NO;
    ProvinceViewController *provinceVC = [[ProvinceViewController alloc] init];
    provinceVC.isAddResident = YES;
    provinceVC.delegate = self;
    provinceVC.homePageVC = self;
    
    [self.navigationController pushViewController:provinceVC animated:YES];
    [provinceVC release];


}

- (void)finishSelectCity:(NSSet *)citySet
{
    NSMutableString *residentStr = [[NSMutableString alloc] init];
    [citySet enumerateObjectsUsingBlock:^(CityInfo *city, BOOL *stop) {
        [residentStr appendFormat:@"%@、", city.cityname];
    }];
    NSLog(@"residentStr; %@", residentStr);
    
    if ([residentStr isValid]) {
        residentStr = [NSMutableString stringWithString:[residentStr substringToIndex:[residentStr length] -  1]];
    }
    
    self.finishSelectCity = YES;
    
    [self.rightArray replaceObjectAtIndex:1 withObject:residentStr];
    [self.mTableView reloadData];
}

- (void)finishSelectPhar:(NSSet *)pharSet
{
    //    NSLog(@"residentarrray: %@", self.residentArray);
    NSMutableString *preferStr = [[NSMutableString alloc] init];
    [pharSet enumerateObjectsUsingBlock:^(Pharmacology *phar, BOOL *stop) {
        [preferStr appendFormat:@"%@、", phar.content];
    }];
    if ([preferStr isValid]) {
        preferStr = [NSMutableString stringWithString:[preferStr substringToIndex:[preferStr length] -  1]];
    }
    
    if ([self.preferid isValid]) {
        self.preferid = [NSMutableString stringWithString:[self.preferid substringToIndex:[self.preferid length]-1]];
    }
    
    self.finishSelectPhar = YES;
    
    [self.rightArray replaceObjectAtIndex:2 withObject:preferStr];
    [self.mTableView reloadData];
}

- (void)selectCategory
{
    NSLog(@"选择偏好");
    SelectPharViewController *selectPreferVC = [[SelectPharViewController alloc] init];
    selectPreferVC.delegate = self;
    [self.navigationController pushViewController:selectPreferVC animated:YES];
    [selectPreferVC release];
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"完善个人信息";
    }
    return nil;
}

- (void)configureCell:(AddInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.leftLabel.text = [self.leftArray objectAtIndex:indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *text = [self.rightArray objectAtIndex:indexPath.row];
    cell.rightLabel.text = text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"addInfoCell";
    AddInfoCell *cell = (AddInfoCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddInfoCell" owner:self options:nil] lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEL sel = [[self.selectorArray objectAtIndex:indexPath.row] pointerValue];
    [self performSelector:sel];
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
        cell.selectImage.image = [UIImage imageNamed:@"unselected.png"];
    }
    else{
        [self.zdDict setObject:[NSNumber numberWithInt:indexPath.row+1] forKey:zdString];
        cell.selectImage.image = [UIImage imageNamed:@"selected.png"];
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
            [self.rightArray replaceObjectAtIndex:0 withObject:@""];
            break;
        case 1:
            [self.rightArray replaceObjectAtIndex:0 withObject:@"招商"];
            break;
        case 2:
            [self.rightArray replaceObjectAtIndex:0 withObject:@"代理"];
            break;
        case 3:
            [self.rightArray replaceObjectAtIndex:0 withObject:@"招商/代理"];
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
            self.finishSelectZD = YES;
            DB_SAVE();
            [self.mTableView reloadData];
        }
        else{
            [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];

    [tableAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mTableView release];
    [super dealloc];
}
@end
