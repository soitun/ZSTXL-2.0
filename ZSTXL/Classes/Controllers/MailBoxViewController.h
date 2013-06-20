//
//  MailBoxViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleView.h"
#import "MailSelectorView.h"
#import "MailInfoViewController.h"

@interface MailBoxViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, TitleViewDelegate, MailSelectorViewDelegate, MailInfoViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) NSMutableDictionary *deleteDict;
@property (nonatomic, retain) NSArray *mailSelectorArray;
@property (nonatomic, retain) UIButton *mailSentButton;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isInbox;
@property (nonatomic, retain) TitleView *titleView;

@property (retain, nonatomic) IBOutlet UIButton *mailWriteButton;
@property (retain, nonatomic) IBOutlet UIButton *mailDeleteButton;
@property (retain, nonatomic) IBOutlet UIButton *mailRefreshButton;

@property (retain, nonatomic) UIControl *bgControl;


@end
