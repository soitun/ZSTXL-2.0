//
//  StarNewsViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreFooter.h"

@interface StarInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LoadMoreFooterDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *dataSourceArray;

@property (assign, nonatomic) NSInteger newsPage;
@property (assign, nonatomic) NSInteger invPage;
@property (copy, nonatomic) NSString *maxrow;
@property (retain, nonatomic) LoadMoreFooter *footer;

@end
