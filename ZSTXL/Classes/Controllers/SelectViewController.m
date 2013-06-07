//
//  SelectViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SelectViewController.h"
#import "SettingCell.h"
#import "CustomCellBackgroundView.h"
#import "ZDCell.h"
#import "PublishCell.h"
#import "ShowSelectViewController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

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
    self.title = @"筛选";
    self.leftArray = @[@"招商/代理", @"类别偏好"];
    self.pharArray = [NSMutableArray array];
    self.tableView.backgroundView = nil;
    
    self.zdNameArray = @[@"招商", @"代理"];
    self.zdDict = [NSMutableDictionary dictionary];
    [self initNavBar];
}

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

#pragma mark - table view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.leftArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PublishCell" owner:nil options:nil] lastObject];

    
    CustomCellBackgroundViewPosition pos;
    
    if (indexPath.row == 0) {
        pos = CustomCellBackgroundViewPositionTop;
    }
    else{
        pos = CustomCellBackgroundViewPositionBottom;
    }
    
    CustomCellBackgroundView *cellBg = [[[CustomCellBackgroundView alloc] initWithFrame:cell.frame] autorelease];
    cellBg.position = pos;
    cellBg.fillColor = [UIColor whiteColor];
    cellBg.borderColor = kCellBorderColor;
    cellBg.cornerRadius = 5.f;
    cell.backgroundView = cellBg;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.nameLabel setTextColor:kContentBlueColor];
    [cell.nameLabel setFont:[UIFont systemFontOfSize:16]];
    cell.nameLabel.text = [self.leftArray objectAtIndex:indexPath.row];
    
    [cell.contentLabel setFont:[UIFont systemFontOfSize:16]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self selectZhaoShangDaiLi];
    }
    else{
        [self selectPharCategory];
    }
}

#pragma mark - table selector

- (void)selectZhaoShangDaiLi
{
    DLog(@"选择招商代理");
    SBTableAlert *tableAlert = [[SBTableAlert alloc] initWithTitle:@"请选择招商代理" cancelButtonTitle:@"确定" messageFormat:nil];
    [tableAlert setType:SBTableAlertTypeMultipleSelct];
    tableAlert.delegate = self;
    tableAlert.dataSource = self;
    [tableAlert show];
}

- (void)selectPharCategory
{
    DLog(@"选择药品类别");
    ShaixuanPharViewController *sxPharVC = [[[ShaixuanPharViewController alloc] init] autorelease];
    sxPharVC.delegate = self;
    [self.navigationController pushViewController:sxPharVC animated:YES];
    
}

- (IBAction)confirm:(UIButton *)sender
{
    if (![self.pharId isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择药品类别" andImageName:kErrorIcon];
        return;
    }else if (self.zdValue.intValue == 0){
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择招商代理" andImageName:kErrorIcon];
        return;
    }
    
//    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"path": @"getZsUserBypreferPage.json",
//                                                                                   @"userid": kAppDelegate.userId,
//                                                                                   @"provinceid": [PersistenceHelper dataForKey:kProvinceId],
//                                                                                   @"cityid": [PersistenceHelper dataForKey:kCityId],
//                                                                                   @"invagency": self.zdValue,
//                                                                                   @"preferid": self.pharId}];
    
    ShowSelectViewController *showVC = [[[ShowSelectViewController alloc] init] autorelease];
    showVC.preferId = self.pharId;
    showVC.invagency = self.zdValue;
    [self.navigationController pushViewController:showVC animated:YES];
    
//    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
//    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
//       
//        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//        if (RETURNCODE_ISVALID(json)) {
//            DLog(@"json %@", json);
//        }
//        else{
//            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
//        }
//        
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
//    }];
    
    
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
            self.zsdl = @"";
            break;
        case 1:
            self.zsdl = @"招商";
            break;
        case 2:
            self.zsdl = @"代理";
            break;
        case 3:
            self.zsdl = @"招商/代理";
            break;
        default:
            break;
    }
    
    for (NSString *key in [self.zdDict allKeys]) {
        [self.zdDict setObject:[NSNumber numberWithInt:0] forKey:key];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    PublishCell *cell = (PublishCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.text = self.zsdl;
    
    [tableAlert release];
}

#pragma mark - shaixuan phar delegate

- (void)shaixuanPharSelectFinish:(NSArray *)array
{
    [self.pharArray removeAllObjects];
    [self.pharArray addObjectsFromArray:array];
    
    NSMutableString *tmp = [NSMutableString string];
    NSMutableString *pharStr = [NSMutableString string];
    for (NSDictionary *dict in self.pharArray) {
        [pharStr appendFormat:@"%@、", [dict objForKey:@"content"]];
        [tmp appendFormat:@"%@,", [dict objForKey:@"id"]];
    }
    
    if ([pharStr isValid]) {
        self.pharContent = [pharStr substringToIndex:pharStr.length-1];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    PublishCell *cell = (PublishCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.text = self.pharContent;
    
    if ([tmp isValid]) {
        self.pharId = [tmp substringToIndex:tmp.length-1];
    }
    
}


@end
