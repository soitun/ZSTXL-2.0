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
    [self initNavBar];
    
    self.tableView.backgroundView = nil;
    self.dupArray = [[NSMutableArray alloc] initWithObjects:@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日", nil];
    
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

#pragma mark - table view

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
    UIPopoverListView *list = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, 20, 280, 340+44)];
    [list setTitle:@"重复"];
    list.listView.scrollEnabled = NO;
    list.datasource = self;
    list.delegate = self;
    [list show];
    [list release];
}

- (void)onDuty
{
    DLog(@"上班");
    self.onDutyTimePicker = [[TimePicker alloc] initWithTitle:@"上班时间" delegate:self];
    self.onDutyTimePicker.datePicker.datePickerMode = UIDatePickerModeTime;
    [self.onDutyTimePicker showInView:self.view];
    [self.onDutyTimePicker release];
}

- (void)offDuty
{
    DLog(@"下班");
    self.offDutyTimePicker = [[TimePicker alloc] initWithTitle:@"下班时间" delegate:self];
    self.offDutyTimePicker.datePicker.datePickerMode = UIDatePickerModeTime;
    [self.offDutyTimePicker showInView:self.view];
    [self.offDutyTimePicker release];
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
    if (picker == self.onDutyTimePicker) {
        
    }else if (picker == self.offDutyTimePicker){
        
    }
}


@end
