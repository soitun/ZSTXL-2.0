//
//  PublishBaseViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmFooterView.h"

@protocol PublishBaseViewControllerDelegate <NSObject>

- (void)publishSelectFinish:(NSArray *)array withType:(NSString *)type;

@end

@interface PublishBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ConfirmFooterViewDelegate>

@property (assign, nonatomic) NSString *type;
@property (retain, nonatomic) UITableView *tableVeiw;
@property (nonatomic, retain) NSArray *titleArray;

@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) NSMutableArray *selectArray;
@property (nonatomic, assign) id<PublishBaseViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL allowMultiSelect;

//重写
- (NSDictionary *)para;
- (void)analyseData:(NSDictionary *)json;
- (NSString *)titleNameOfDict:(NSDictionary *)dict;

@end
