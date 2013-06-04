//
//  WeekDayViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-4.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmFooterView.h"

@protocol WeekDayViewControllerDelegate <NSObject>

- (void)weekDaySelect:(NSMutableArray *)array;

@end

@interface WeekDayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ConfirmFooterViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *weekArray;
@property (retain, nonatomic) NSMutableArray *selectArray;
@property (assign, nonatomic) id<WeekDayViewControllerDelegate> delegate;

@end
