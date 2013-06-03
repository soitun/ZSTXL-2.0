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

@interface MailBoxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TitleViewDelegate, MailSelectorViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) NSArray *mailSelectorArray;
@property (nonatomic, retain) UIButton *mailSentButton;


- (IBAction)mailTransmit:(UIButton *)sender;
- (IBAction)mailRefresh:(UIButton *)sender;
- (IBAction)mailDelete:(UIButton *)sender;
- (IBAction)mailWrite:(UIButton *)sender;


@end
