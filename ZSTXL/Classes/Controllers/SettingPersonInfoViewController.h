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

@interface PersonBasicInfoSettingViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, PersonBasicInfoCellDelegate, UIActionSheetDelegate, TimePickerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *useridLabel;
@property (retain, nonatomic) IBOutlet UILabel *telLabel;
@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) UIButton *saveButton;


@property (nonatomic, retain) TimePicker *timePicker;

@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *selectorArray;

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *birth;

@property (nonatomic, retain) NSDate *birthDate;
@property (nonatomic, retain) MyInfo *myInfo;

@end
