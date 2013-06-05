//
//  SelectPharViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-5.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectPharViewControllerDelegate <NSObject>

- (void)selectPharFinished:(NSArray *)array;

@end

@interface SelectPharViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;
@property (retain, nonatomic) NSMutableArray *selectArray;
@property (assign, nonatomic) id<SelectPharViewControllerDelegate> delegate;

@end
