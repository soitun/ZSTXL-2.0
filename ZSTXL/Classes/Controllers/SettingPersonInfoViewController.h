//
//  PersonBasicInfoSettingViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonBasicInfoCell.h"
#import "TimePicker.h"
#import "MyInfo.h"
#import "UserDetail.h"
#import "SettingPersonInfoHeader.h"

@interface SettingPersonInfoViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, PersonBasicInfoCellDelegate, UIActionSheetDelegate, TimePickerDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) UIButton *saveButton;
@property (retain, nonatomic) SettingPersonInfoHeader *header;

@property (nonatomic, retain) TimePicker *timePicker;

@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSArray *selectorArray;

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *birth;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *position;

@property (nonatomic, retain) NSDate *birthDate;
@property (nonatomic, retain) MyInfo *myInfo;

@end
