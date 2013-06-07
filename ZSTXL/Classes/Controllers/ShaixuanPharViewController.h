//
//  ShaixuanPharViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-6.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShaixuanPharViewControllerDelegate <NSObject>

- (void)shaixuanPharSelectFinish:(NSArray *)array;

@end

@interface ShaixuanPharViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;
@property (retain, nonatomic) NSMutableArray *selectArray;
@property (assign, nonatomic) id<ShaixuanPharViewControllerDelegate> delegate;
@end
