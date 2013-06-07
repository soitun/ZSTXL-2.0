//
//  AllContactViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-22.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopContactView.h"
#import "ContactCell.h"
#import "LoadMoreFooter.h"

@interface AllContactViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PopContactViewDelegate, ContactCellDelegate, LoadMoreFooterDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) NSMutableArray *searchArray;
@property (nonatomic, retain) UIViewController *parentController;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *maxrow;
@property (nonatomic, assign) NSInteger sortid;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDC;

@property (nonatomic, retain) LoadMoreFooter *footer;

- (void)refreshAction;


@end
