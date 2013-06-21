//
//  SearchInvAgencyViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreFooter.h"

@interface SearchInvAgencyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, LoadMoreFooterDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) LoadMoreFooter *footer;

@property (retain, nonatomic) NSMutableArray *dataSourceArray;
@property (copy, nonatomic) NSString *searchKey;
@property (assign, nonatomic) NSInteger page;
@property (copy, nonatomic) NSString *maxrow;

@end
