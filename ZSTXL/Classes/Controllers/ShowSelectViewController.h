//
//  ShowSelectViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-6.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreFooter.h"
#import "ContactCell.h"
#import "PopContactView.h"
#import "SearchContact.h"

@interface ShowSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LoadMoreFooterDelegate, ContactCellDelegate, PopContactViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;
@property (retain, nonatomic) LoadMoreFooter *footer;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSString *maxrow;
@property (retain, nonatomic) NSMutableArray *eachArray;
@property (retain, nonatomic) PopContactView *contactView;
@property (assign, nonatomic) BOOL finish;
@property (assign, nonatomic) BOOL footerIsOn;

@property (copy, nonatomic) NSString *preferId;
@property (copy, nonatomic) NSNumber *invagency;
@property (retain, nonatomic) Contact *contact;


@end
