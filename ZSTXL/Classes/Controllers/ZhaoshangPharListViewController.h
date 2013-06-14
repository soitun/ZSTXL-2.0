//
//  ZhaoshangPharListViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-14.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhaoshangPharListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;

@property (assign, nonatomic) NSInteger page;
@property (copy, nonatomic) NSString *maxrow;
@property (copy, nonatomic) NSString *classifyId;
@property (copy, nonatomic) NSString *pharName;

@end
