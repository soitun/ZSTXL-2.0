//
//  StarInvAgencyViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-18.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreFooter.h"

@interface CustomBaseTableViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, LoadMoreFooterDelegate, UIScrollViewDelegate>

@property (retain, nonatomic) NSMutableArray *dataSourceArray;
@property (assign, nonatomic) LoadMoreFooter *footer;
@property (retain, nonatomic) UIViewController *parentController;
@property (retain, nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger page;
@property (copy, nonatomic) NSString *maxrow;
@property (assign, nonatomic) BOOL reloading;
@property (nonatomic, retain) EGORefreshTableHeaderView *egoView;

@property (assign, nonatomic) BOOL isDataFromDB;


- (void)requestDataFromDB;
- (void)saveDataToDB;
- (void)LoadMoreFooterTap:(LoadMoreFooter *)footer;

- (void)requestData;
- (NSDictionary *)requestPara;
- (NSString *)parseKey;
- (void)parseData:(NSDictionary *)json;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (UIViewController *)tableView:(UITableView *)tableView pushRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end
