//
//  BlacklistViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlacklistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;

@end
