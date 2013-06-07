//
//  SearchContactViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreFooter.h"
#import "PopContactView.h"
#import "ContactCell.h"

@interface SearchContactViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate, LoadMoreFooterDelegate, PopContactViewDelegate, ContactCellDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) LoadMoreFooter *footer;



@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *maxrow;
@property (nonatomic, assign) NSInteger page;

@end
