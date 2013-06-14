//
//  ZhaoshangDailiViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoAdvHeaderView.h"
#import "NewsInfo.h"
#import "EGORefreshTableHeaderView.h"


@interface ZhaoshangDailiViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, EGORefreshTableHeaderDelegate, InfoAdvDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) UIButton *CateButton;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *maxrow;
@property (nonatomic, retain) EGORefreshTableHeaderView *egoView;
@property (nonatomic, assign) BOOL reloading;

@end
