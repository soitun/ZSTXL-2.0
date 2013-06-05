//
//  SettingWorkTimeViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-28.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingWorkTimeViewController.h"
#import "SettingDupCell.h"
#import "SettingCell.h"
#import "CustomCellBackgroundView.h"
#import "UIPopoverListView.h"
#import "TimePicker.h"
#import "WeekDayViewController.h"

@interface SettingWorkTimeViewController ()

@end

@implementation SettingWorkTimeViewController

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
    self.title = @"工作时间";
    [self initTableData];
    [self initTableFooter];
    [self initNavBar];
    
    self.startTime = [[[NSString alloc] init] autorelease];
    self.endTime = [[[NSString alloc] init] autorelease];
    self.view.backgroundColor = bgGreyColor;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.dupArray = [[NSMutableArray alloc] initWithObjects:@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日", nil];
    
    [self requestWorkTime];
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

#pragma mark - work time

- (void)saveAction
{
    if (![self.weekDate isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择工作日" andImageName:kErrorIcon];
        return;
    }
    
    if (![self.startTime isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择上班时间" andImageName:kErrorIcon];
        return;
    }
    
    if (![self.endTime isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请选择下班时间" andImageName:kErrorIcon];
        return;
    }
    
    NSDictionary *para = @{@"path": @"changeWorkTime.json",
                           @"userid": [PersistenceHelper dataForKey:kUserId],
                           @"weekdate": self.weekDate,
                           @"starttime": self.startTime,
                           @"endtime": self.endTime};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            DLog(@"json %@",json);
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
    }];
}

- (void)requestWorkTime
{
    NSDictionary *para = @{@"path": @"getWorkTime.json",
                           @"userid": [PersistenceHelper dataForKey:kUserId]};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            DLog(@"json %@",json);
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        DLog(@"error %@", error);
    }];
}

#pragma mark - table view

- (void)initTableFooter
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保 存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"setting_confirm"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"setting_confirm_p"] forState:UIControlStateHighlighted];
    saveButton.frame = CGRectMake(111, 10, 98, 48);
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:saveButton];
    
    [self.tableView setTableFooterView:footerView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:nil options:nil] lastObject];
    cell.frame = CGRectMake(0, 0, 320, 44);
    CustomCellBackgroundViewPosition pos;
    
    if (indexPath.row == self.titleArray.count-1) {
        pos = CustomCellBackgroundViewPositionBottom;
    }
    else if (indexPath.row == 0){
        pos = CustomCellBackgroundViewPositionTop;
    }
    else{
        pos = CustomCellBackgroundViewPositionMiddle;
    }
    
    CustomCellBackgroundView *cellBgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
    cellBgView.fillColor = [UIColor whiteColor];
    cellBgView.borderColor = kCellBorderColor;
    cellBgView.cornerRadius = 5.f;
    cellBgView.position = pos;
    cell.selectImage.hidden = YES;
    
    cell.backgroundView = cellBgView;
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    ((CustomCellBackgroundView *)(cell.backgroundView)).backgroundColor = kCellSelectColor;
    
    SEL sel = NSSelectorFromString([self.selectorArray objectAtIndex:indexPath.row]);
    [self performSelector:sel];
}

#pragma mark - table data

- (void)initTableData
{
    self.titleArray = [NSMutableArray arrayWithObjects:@"重复", @"上班", @"下班", nil];
    self.selectorArray = [NSMutableArray arrayWithObjects:@"duplicate", @"onDuty", @"offDuty", nil];
}

#pragma mark - table selector

- (void)duplicate
{
    DLog(@"设置重复");
//    UIPopoverListView *list = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, 20, 280, 340+44)];
//    [list setTitle:@"重复"];
//    list.listView.scrollEnabled = NO;
//    list.datasource = self;
//    list.delegate = self;
//    [list show];
//    [list release];
    
    WeekDayViewController *weekDayVC = [[[WeekDayViewController alloc] init] autorelease];
    weekDayVC.delegate = self;
    [self.navigationController pushViewController:weekDayVC animated:YES];
}

- (void)onDuty
{
    DLog(@"上班");
    if (!self.isPickerOn) {
        self.isPickerOn = YES;
        self.onDutyTimePicker = [[TimePicker alloc] initWithTitle:@"上班时间" delegate:self];
        self.onDutyTimePicker.datePicker.datePickerMode = UIDatePickerModeTime;
        [self.onDutyTimePicker showInView:self.view];
    }

}

- (void)offDuty
{
    DLog(@"下班");
    if (!self.isPickerOn) {
        self.isPickerOn = YES;
        self.offDutyTimePicker = [[TimePicker alloc] initWithTitle:@"下班时间" delegate:self];
        self.offDutyTimePicker.datePicker.datePickerMode = UIDatePickerModeTime;
        [self.offDutyTimePicker showInView:self.view];
    }

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

#pragma mark - pop over list view

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView cellForIndexPath:(NSIndexPath *)indexPath
{
    SettingDupCell *settingCell = [[[NSBundle mainBundle] loadNibNamed:@"SettingDupCell" owner:nil options:nil] lastObject];
    settingCell.titleLabel.text = [self.dupArray objectAtIndex:indexPath.row];
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return settingCell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)popoverListViewCancel:(UIPopoverListView *)popoverListView
{
    
}

- (void)popoverListconfirmSelect:(NSMutableArray *)array
{
    DLog(@"pop select array %@", array);
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

#pragma mark - time picker delegate

- (void)timePickerConfirm:(TimePicker *)picker
{
    self.isPickerOn = NO;
    if (picker == self.onDutyTimePicker) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        self.startTime = [dateFormatter stringFromDate:picker.datePicker.date];
    }else if (picker == self.offDutyTimePicker){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        self.endTime = [dateFormatter stringFromDate:picker.datePicker.date];
    }
}

- (void)timePickerCancel:(TimePicker *)picker
{
    self.isPickerOn = NO;
}

//- (void)updateTime:(NSString *)time withDatePicker:(TimePicker *)picker
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH:mm:ss"];
//    dateFormatter.timeZone = [NSTimeZone localTimeZone];
//    time = [[NSString alloc] initWithString:[dateFormatter stringFromDate:picker.datePicker.date]];
//    DLog(@"time %@", time);
//}

#pragma mark - weekdat delegate

- (void)weekDaySelect:(NSMutableArray *)array
{
    NSMutableString *tmp = [NSMutableString string];
    for (NSString *str in array) {
        [tmp appendFormat:@"%@,", str];
    }
    
    if ([tmp isValid]) {
        self.weekDate = [tmp substringToIndex:tmp.length-1];
    }
    
//    DLog(@"week day %@", self.weekDate);
}


@end
