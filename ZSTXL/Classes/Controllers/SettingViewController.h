//
//  SettingViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingCell.h"
#import "DeleteChatView.h"

@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SettingCellDelegate, UIAlertViewDelegate, DeleteChatViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *settingInfo;
@property (nonatomic, retain) NSMutableArray *selectorArray;
@property (nonatomic, assign) BOOL toneOn;

@property (nonatomic, assign) int allowFriendContact;

@end
