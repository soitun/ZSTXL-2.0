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
    
    self.pickerViewDate = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:nil
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:nil];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy MM dd"];
    
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:tz];
    
    self.theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    self.theDatePicker.datePickerMode = UIDatePickerModeDate;
    self.theDatePicker.timeZone = [NSTimeZone localTimeZone];
    NSDate *maxDate = [NSDate date];
    NSDate *minDate = [dateFormatter dateFromString:@"1950 01 01"];
    
    

    [self.theDatePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    self.theDatePicker.maximumDate = maxDate;
    self.theDatePicker.minimumDate = minDate;
    
    self.pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.pickerToolbar.barStyle=UIBarStyleBlackTranslucent;
    [self.pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(DatePickerDoneClick)];

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:self
                                                                               action:nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(DatePickerCancelClick)];
    [barItems addObject:cancelButton];
    [barItems addObject:flexSpace];
    [barItems addObject:doneButton];
    
    [self.pickerToolbar setItems:barItems animated:YES];
    [self.pickerViewDate addSubview:self.pickerToolbar];
    [self.pickerViewDate addSubview:self.theDatePicker];
    [self.pickerViewDate showInView:self.view];
    self.pickerViewDate.frame = CGRectMake(0, SCREEN_HEIGHT-64-44-self.theDatePicker.frame.size.height, 320, self.theDatePicker.frame.size.height+44);
}

- (void)DatePickerDoneClick
{
    [self.pickerViewDate dismissWithClickedButtonIndex:0 animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    self.birthDate = self.theDatePicker.date;
    
    DLog(@"date %@", [dateFormatter stringFromDate:self.theDatePicker.date]);
}

- (void)DatePickerCancelClick
{
    [self.pickerViewDate dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dateChanged
{
    
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
