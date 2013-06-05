//
//  SelectCityViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-5.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCityViewControllerDelegate <NSObject>

- (void)SelectCityFinished:(NSArray *)array;

@end

@interface SelectCityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;
@property (retain, nonatomic) NSMutableArray *selectArray;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, retain) NSIndexPath *selectIndex;
@property (nonatomic, assign) BOOL allowMultiselect;

@property (nonatomic, assign) id<SelectCityViewControllerDelegate> delegate;

@end
