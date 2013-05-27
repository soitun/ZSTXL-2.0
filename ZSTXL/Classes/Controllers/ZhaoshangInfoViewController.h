//
//  ZhaoshangInfoViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhaoshangInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *contentArray;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSDictionary *contactInfo;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
