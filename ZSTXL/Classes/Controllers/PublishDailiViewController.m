//
//  PublishDailiViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishDailiViewController.h"
#import "SettingCell.h"
#import "ConfirmFooterView.h"
#import "PublishDailiToViewController.h"
#import "PublishSellToViewController.h"
#import "PublishPeriodViewController.h"
#import "PublishDailiAdvantageViewController.h"

#import "PublishCell.h"



@interface PublishDailiViewController ()

@end

@implementation PublishDailiViewController

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
    self.title = @"发布代理";
    self.titleArray = @[@"代理方向：", @"代理区域：", @"代理渠道：", @"代理优势：", @"信息有效期："];
    self.selectorArray = @[@"dailiTo", @"dailiArea", @"dailiChnnel", @"dailiAdvantage", @"infoPeriod"];
    
    self.tableView.backgroundView = nil;
    self.view.backgroundColor = bgGreyColor;
    [self initNavBar];
    [self initTableFooter];
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

#pragma mark - nav back button

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

#pragma mark - table view

- (void)initTableFooter
{
    ConfirmFooterView *footer = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmFooterView" owner:nil options:nil] lastObject];
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"PublishCell";
    PublishCell *commonCell = (PublishCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (commonCell == nil) {
        commonCell = [[[NSBundle mainBundle] loadNibNamed:@"PublishCell" owner:nil options:nil] lastObject];
    }
    
    [Utility groupTableView:tableView addBgViewForCell:commonCell withCellPos:CustomCellBackgroundViewPositionSingle];
    commonCell.nameLabel.text = [self.titleArray objectAtIndex:indexPath.section];
    return commonCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEL sel = NSSelectorFromString([self.selectorArray objectAtIndex:indexPath.section]);
    [self performSelector:sel];
}

- (void)dailiTo
{
    //药品
    PublishDailiToViewController *publishDailiToVC = [[[PublishDailiToViewController alloc] init] autorelease];
    publishDailiToVC.type = @"0";
    publishDailiToVC.allowMultiSelect = YES;
    publishDailiToVC.delegate = self;
    [self.navigationController pushViewController:publishDailiToVC animated:YES];
}

- (void)dailiArea
{
    SelectCityViewController *selectCityVC = [[[SelectCityViewController alloc] init] autorelease];
    selectCityVC.delegate = self;
    selectCityVC.allowMultiselect = NO;
    [self.navigationController pushViewController:selectCityVC animated:YES];
}

- (void)dailiChnnel
{
    
    PublishSellToViewController *publishSellToVC = [[[PublishSellToViewController alloc] init] autorelease];
    publishSellToVC.type = @"2";
    publishSellToVC.allowMultiSelect = YES;
    publishSellToVC.delegate = self;
    [self.navigationController pushViewController:publishSellToVC animated:YES];
}

- (void)dailiAdvantage
{
    PublishDailiAdvantageViewController *publishDailiAdvantageViewController = [[[PublishDailiAdvantageViewController alloc] init] autorelease];
    publishDailiAdvantageViewController.delegate = self;
    [self.navigationController pushViewController:publishDailiAdvantageViewController animated:YES];
}

- (void)infoPeriod
{
    PublishPeriodViewController *publishPeriodVC = [[[PublishPeriodViewController alloc] init] autorelease];
    publishPeriodVC.type = @"4";
    publishPeriodVC.delegate = self;
    [self.navigationController pushViewController:publishPeriodVC animated:YES];
}

#pragma mark - confirm footer

- (void)confirmFooterViewLeftAction
{
    if (![self.durgclassificationid isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择代理方向" andImageName:kErrorIcon];
        return;
    }else if (![self.cityId isValid]){
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择代理区域" andImageName:kErrorIcon];
        return;
    }else if (![self.direction isValid]){
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择代理渠道" andImageName:kErrorIcon];
        return;
    }else if (![self.advantage isValid]){
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入代理优势" andImageName:kErrorIcon];
        return;
    }else if (![self.duration isValid]){
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择信息有效期" andImageName:kErrorIcon];
        return;
    }
    
    NSDictionary *para = @{@"path": @"addAgency.json",
                           @"durgclassificationid": self.durgclassificationid,
                           @"proviceid": self.provinceId,
                           @"cityid": self.cityId,
                           @"direction": self.direction,
                           @"superiority": self.advantage,
                           @"duration": self.duration};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    hud.labelText = @"发布代理信息";
    
    [DreamFactoryClient postWithParameters:para image:nil success:^(id response) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        
        if ([[[(NSDictionary *)response objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            [kAppDelegate showWithCustomAlertViewWithText:@"发送代理信息成功" andImageName:nil];
        } else {
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(response) andImageName:nil];
        }
    } failure:^{
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)confirmFooterViewRightAction
{
    [self popVC:nil];
}

#pragma mark - selectcity delegate

- (void)SelectCityFinished:(NSArray *)array
{
    NSDictionary *city = [array lastObject];
    self.provinceId = [city objForKey:@"provinceid"];
    self.cityId = [city objForKey:@"cityid"];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    PublishCell *cell = (PublishCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.text = [city objForKey:@"cityname"];
}

#pragma mark - select period delegate

- (void)publishSelectFinish:(NSArray *)array withType:(NSString *)type
{
        //信息有效期
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:type.intValue];
    PublishCell *cell = (PublishCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    switch (type.intValue) {
        case 0:
        {
            NSMutableString *phar = [NSMutableString string];
            NSMutableString *str = [NSMutableString string];
            for (NSDictionary *dict in array) {
                NSString *pharid = [dict objForKey:@"id"];
                [str appendFormat:@"%@,", pharid];
                
                NSString *content = [dict objForKey:@"content"];
                [phar appendFormat:@"%@、", content];
            }
            if ([str isValid]) {
                self.durgclassificationid = [str substringToIndex:str.length-1];
                cell.contentLabel.text = [phar substringToIndex:phar.length-1];
            }
        }
            break;
        case 2:
        {
            NSMutableString *str = [NSMutableString string];
            for (NSDictionary *dict in array) {
                NSString *pharid = [dict objForKey:@"content"];
                [str appendFormat:@"%@、", pharid];
            }
            if ([str isValid]) {
                self.direction = [str substringToIndex:str.length-1];
                cell.contentLabel.text = self.direction;
            }
        }
            break;
        case 4:
        {
            self.duration = [NSString stringWithFormat:@"%d", [[[array lastObject] objForKey:@"col4"] intValue]];
            cell.contentLabel.text = [[array lastObject] objForKey:@"content"];
        }
            break;
        default:
            break;
    }
}

- (void)publishDailiAdvantageFinish:(NSString *)string
{
    self.advantage = string;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    PublishCell *cell = (PublishCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.text = self.advantage;
}

@end
