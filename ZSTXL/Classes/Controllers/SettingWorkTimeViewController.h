//
//  SettingWorkTimeViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-28.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"
#import "TimePicker.h"

@interface SettingWorkTimeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPopoverListViewDelegate, UIPopoverListViewDataSource, TimePickerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *contentArray;
@property (nonatomic, retain) NSMutableArray *selectorArray;

@property (nonatomic, retain) NSMutableArray *dupArray;
@property (nonatomic, retain) TimePicker *onDutyTimePicker;
@property (nonatomic, retain) TimePicker *offDutyTimePicker;
@property (nonatomic, retain) NSDate *onDutyTime;
@property (nonatomic, retain) NSDate *offDutyTime;

@end
