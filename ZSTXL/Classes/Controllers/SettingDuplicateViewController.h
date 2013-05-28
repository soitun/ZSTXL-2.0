//
//  SettingDuplicateViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-28.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingDuplicateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *titleArray;
@end
