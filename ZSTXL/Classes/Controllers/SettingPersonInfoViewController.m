//
//  PersonBasicInfoSettingViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingPersonInfoViewController.h"
#import "CustomCellBackgroundView.h"
#import "PersonBasicInfoCell.h"
#import "SettingNameViewController.h"
#import "SettingTelViewController.h"
#import "TimePicker.h"


enum EnumAlert {
    companyAlert = 0,
    positionAlert = 1
    };

@interface SettingPersonInfoViewController ()

@end

@implementation SettingPersonInfoViewController

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
    self.view.backgroundColor = bgGreyColor;
    self.sex = @"";
    
    [self initNavBar];
    [self initTableView];
    [self initTableHeader];
    
    self.myInfo = [Utility getMyInfo];
    self.header.userIdLabel.text = kAppDelegate.userId;
    self.header.telLabel.text = self.myInfo.userDetail.tel;
    
    NSString *picUrl = [NSString stringWithFormat:@"%@.jpg", kAppDelegate.userId];
    self.header.avatar.image = [Utility readImageFromDisk:picUrl];
    
    [self requestPersonInfo];
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


#pragma mark - table view

- (void)initTableHeader
{
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"SettingPersonInfoHeader" owner:self options:nil] lastObject];
    self.tableView.tableHeaderView = self.header;
}

- (void)initTableView
{
    self.titleArray = @[@[@"姓名", @"手机号码"], @[@"性别", @"生日"], @[@"单位", @"职位"]];
    self.selectorArray = @[@[@"settingName", @"settingTel"], @[@"settingSex", @"settingBirth"], @[@"settingCompany", @"settingJob"]];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    footerView.backgroundColor = [UIColor clearColor];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setBackgroundImage:[UIImage imageByName:@"setting_confirm_l"] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[UIImage imageByName:@"setting_confirm_l_p"] forState:UIControlStateHighlighted];
    [self.saveButton setTitle:@"保 存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.frame = CGRectMake(15, 10, 289, 48);
    [footerView addSubview:self.saveButton];
    
    self.tableView.tableFooterView = footerView;
    
}

- (void)requestPersonInfo
{
    NSDictionary *para = @{@"path": @"getZsUserBirthdate.json",
                           @"userid": [PersistenceHelper dataForKey:kUserId]};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            
            DLog(@"json %@", json);
            self.birth = [json objForKey:@"userBirthdate"];
            self.sex = [[json objForKey:@"userSex"] removeSpace];
            self.company = [json objForKey:@"CompanyName"];
            self.position = [json objForKey:@"Position"];
            [self.tableView reloadData];
            
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
    }];
}

- (void)saveAction
{
    
    NSDictionary *para = @{@"path": @"changeZsUserBirthdate.json",
                           @"userid": [PersistenceHelper dataForKey:kUserId],
                           @"sex": self.sex,
                           @"birthdate": self.birth,
                           @"companyname": self.company,
                           @"position": self.position};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            [kAppDelegate showWithCustomAlertViewWithText:@"保存成功" andImageName:nil];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
    }];
    
}

#pragma mark - table view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.f;
    
    if (section == 0) {
        height = 0.f;;
    }
    else{
        height = 8.f;
    }
    
    return height;
}

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
        cell.maleButton.hidden = NO;
        cell.femaleButton.hidden = NO;
        
        if (![self.sex isValid]) {
            [cell.maleButton setImage:[UIImage imageNamed:@"login_noselect"] forState:UIControlStateNormal];
            [cell.femaleButton setImage:[UIImage imageNamed:@"login_noselect"] forState:UIControlStateNormal];
        }
        else{
            if ([self.sex isEqualToString:@"男"]) {
                [cell.maleButton setImage:[UIImage imageNamed:@"login_select"] forState:UIControlStateNormal];
                [cell.femaleButton setImage:[UIImage imageNamed:@"login_noselect"] forState:UIControlStateNormal];
            }
            else{
                [cell.maleButton setImage:[UIImage imageNamed:@"login_noselect"] forState:UIControlStateNormal];
                [cell.femaleButton setImage:[UIImage imageNamed:@"login_select"] forState:UIControlStateNormal];
            }
        }
        
        
    } else if (indexPath.section ==0 && indexPath.row == 0){
        cell.detailLabel.text = self.myInfo.userDetail.username;
    } else if (indexPath.section == 1 && indexPath.row == 1){
        cell.detailLabel.text = self.birth;
    } else if (indexPath.section == 2 && indexPath.row == 0){
        cell.detailLabel.text = self.company;
    } else if (indexPath.section == 2 && indexPath.row == 1){
        cell.detailLabel.text = self.position;
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
}


- (void)settingCompany
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改单位名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.delegate = self;
    textField.placeholder = @"单位";
    textField.tag = companyAlert;
    textField.clearsOnBeginEditing = YES;
    alert.tag = companyAlert;
    [alert show];
    [alert release];
}

- (void)settingJob
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改职位名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.delegate = self;
    textField.placeholder = @"职位";
    textField.clearsOnBeginEditing = YES;
    textField.tag = positionAlert;
    alert.tag = positionAlert;
    [alert show];
    [alert release];
}


#pragma mark - timer picker delegate

- (void)timePickerConfirm:(TimePicker *)picker
{
    [picker dismissWithClickedButtonIndex:0 animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    self.birthDate = picker.datePicker.date;
    self.birth = [dateFormatter stringFromDate:picker.datePicker.date];
    [self.tableView reloadData];
    
    DLog(@"date %@", self.birth);
    
}

- (void)timePickerCancel:(TimePicker *)picker
{
    [picker dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - person cell delegate

- (void)chooseMale:(PersonBasicInfoCell *)cell
{
    self.sex = @"男";
    [cell.maleButton setImage:[UIImage imageNamed:@"login_select"] forState:UIControlStateNormal];
    [cell.femaleButton setImage:[UIImage imageNamed:@"login_noselect"] forState:UIControlStateNormal];
}

- (void)chooseFemale:(PersonBasicInfoCell *)cell
{
    self.sex = @"女";
    [cell.maleButton setImage:[UIImage imageNamed:@"login_noselect"] forState:UIControlStateNormal];
    [cell.femaleButton setImage:[UIImage imageNamed:@"login_select"] forState:UIControlStateNormal];
}

#pragma mark - alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == companyAlert) {
        if (buttonIndex == 0) {
            
        }
        else{
            self.company = [[alertView textFieldAtIndex:0] text];
        }
    }
    else{
        if (buttonIndex == 0) {
            
        }
        else{
            self.position = [[alertView textFieldAtIndex:0] text];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == companyAlert) {
        self.company = textField.text;
    }
    else{
        self.position = textField.text;
    }
}

@end
