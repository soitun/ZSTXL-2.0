//
//  AllContactViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-22.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllContactViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) NSMutableArray *searchArray;
@property (nonatomic, retain) UIViewController *parentController;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger sortid;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDC;



@end
