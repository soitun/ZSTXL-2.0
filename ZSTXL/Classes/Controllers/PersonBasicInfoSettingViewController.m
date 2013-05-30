//
//  PersonBasicInfoSettingViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PersonBasicInfoSettingViewController.h"
#import "CustomCellBackgroundView.h"
#import "PersonBasicInfoCell.h"
#import "SettingNameViewController.h"
#import "SettingTelViewController.h"
#import "TimePicker.h"

@interface PersonBasicInfoSettingViewController ()

@end

@implementation PersonBasicInfoSettingViewController

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
    self.title = @"个人信息设置";
    self.userid = @"123456";
    self.tel = @"13800000001";
    
    self.name = @"张三";
    self.birth = @"1990-00-00";
    
    
    self.isMale = YES;
    
    self.useridLabel.text = self.userid;
    self.telLabel.text = self.tel;
    
    [self initNavBar];
    [self initTableViewData];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableView release];
    [_useridLabel release];
    [_telLabel release];
    [_headIcon release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setUseridLabel:nil];
    [self setTelLabel:nil];
    [self setHeadIcon:nil];
    [self setTableView:nil];
    [super viewDidUnload];
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
    NSArray *titleArr1 = @[@"姓名", @"手机号码"];
    NSArray *titleArr2 = @[@"性别", @"生日"];
    self.titleArray = [NSMutableArray arrayWithObjects:titleArr1, titleArr2, nil];
    
    NSArray *selArr1 = @[@"settingName", @"settingTel"];
    NSArray *selArr2 = @[@"settingSex", @"settingBirth"];
    self.selectorArray = [NSMutableArray arrayWithObjects:selArr1, selArr2, nil];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titleArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"PersonBasicInfoCell";
    PersonBasicInfoCell *cell = (PersonBasicInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonBasicInfoCell" owner:nil options:nil] lastObject];
    }

    cell.titleLabel.text = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.frame = CGRectMake(0, 0, 320, 44);
    CustomCellBackgroundViewPosition pos;
    if (indexPath.row == [[self.titleArray objectAtIndex:indexPath.section] count]-1) {
        pos = CustomCellBackgroundViewPositionBottom;
    }
    else if (indexPath.row == 0){
        pos = CustomCellBackgroundViewPositionTop;
    }
    
    CustomCellBackgroundView *cellBgView = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
    cellBgView.position = pos;
    cellBgView.fillColor = [UIColor whiteColor];
    cellBgView.borderColor = kCellBorderColor;
    cellBgView.cornerRadius = 5.f;
    cell.backgroundView = cellBgView;
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.delegate = self;
        cell.detailLabel.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.maleLabel.hidden = NO;
        cell.femaleLabel.hidden = NO;
        cell.chooseMaleImage.hidden = NO;
        cell.chooseFemaleImage.hidden = NO;
    } else if (indexPath.section ==0 && indexPath.row == 0){
        cell.detailLabel.text = self.name;
    } else if (indexPath.section == 1 && indexPath.row == 1){
        cell.detailLabel.text = self.birth;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEL sel = NSSelectorFromString([[self.selectorArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
    [self performSelector:sel];
}

#pragma mark - table selector

- (void)settingName
{
    DLog(@"settingName");
    SettingNameViewController *settingNameVC = [[[SettingNameViewController alloc] init] autorelease];
    [self.navigationController pushViewController:settingNameVC animated:YES];
}

- (void)settingTel
{
    DLog(@"settingTel");
    SettingTelViewController *settingTelVC = [[[SettingTelViewController alloc] init] autorelease];
    [self.navigationController pushViewController:settingTelVC animated:YES];
}

- (void)settingSex
{
    DLog(@"settingSex");
}

- (void)settingBirth
{
    DLog(@"settingBirth");
    
    
    self.timePicker = [[TimePicker alloc] initWithTitle:@"设置生日" delegate:self];
    self.timePicker.datePicker.datePickerMode = UIDatePickerModeDate;
    self.timePicker.datePicker.timeZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy MM dd"];
    
    NSDate *maxDate = [NSDate date];
    NSDate *minDate = [dateFormatter dateFromString:@"1950 01 01"];
    self.timePicker.datePicker.maximumDate = maxDate;
    self.timePicker.datePicker.minimumDate = minDate;
    
    [self.timePicker showInView:self.view];
    [self.timePicker release];
}

- (void)timePickerConfirm:(TimePicker *)picker
{
    [picker dismissWithClickedButtonIndex:0 animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    self.birthDate = picker.datePicker.date;
    
    DLog(@"date %@", [dateFormatter stringFromDate:picker.datePicker.date]);
}

- (void)timePickerCancel:(TimePicker *)picker
{
    [picker dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - person cell delegate

- (void)chooseMale:(PersonBasicInfoCell *)cell
{
    if (!self.isMale) {
        self.isMale = YES;
        cell.chooseMaleImage.image = [UIImage imageNamed:@"login_select"];
        cell.chooseFemaleImage.image = [UIImage imageNamed:@"login_noselect"];
    }
}

- (void)chooseFemale:(PersonBasicInfoCell *)cell
{
    if (self.isMale) {
        self.isMale = NO;
        cell.chooseMaleImage.image = [UIImage imageNamed:@"login_noselect"];
        cell.chooseFemaleImage.image = [UIImage imageNamed:@"login_select"];
    }
}

@end
