//
//  MyInvAgencyViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-15.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreFooter.h"

@interface MyInvAgencyViewController : UIViewController <UITableViewDataSource, UITabBarDelegate, LoadMoreFooterDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;
@property (retain, nonatomic) LoadMoreFooter *footer;

@property (assign, nonatomic) NSInteger page;
@property (copy, nonatomic) NSString *maxrow;

@end
