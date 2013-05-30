//
//  PharCategoryViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PharCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@end
