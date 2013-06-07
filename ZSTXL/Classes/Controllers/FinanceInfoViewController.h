//
//  FinanceInfoViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-7.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *accountLabel;
@property (retain, nonatomic) IBOutlet UILabel *gradeLabel;
@property (retain, nonatomic) IBOutlet UILabel *creditLabel;
@property (retain, nonatomic) IBOutlet UILabel *telLabel;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)rechargeAction:(UIButton *)sender;
- (IBAction)queryAction:(UIButton *)sender;

@property (retain, nonatomic) NSArray *leftArray;

@end
