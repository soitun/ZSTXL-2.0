//
//  PublishDailiViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmFooterView.h"

@interface PublishDailiViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ConfirmFooterViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSArray *selectorArray;
@end
