//
//  PharCategoryViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishView.h"
#import "PharCategoryCell.h"

@interface PharCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, PublishViewDelegate, PharCategoryCellDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) UIControl *bgControl;

@end
