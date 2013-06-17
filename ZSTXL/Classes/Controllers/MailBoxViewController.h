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

- (IBAction)mailRefresh:(UIButton *)sender;
- (IBAction)mailDelete:(UIButton *)sender;
- (IBAction)mailWrite:(UIButton *)sender;


@end
