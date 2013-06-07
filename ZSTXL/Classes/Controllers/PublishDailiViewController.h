//
//  PublishDailiViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmFooterView.h"
#import "SelectCityViewController.h"
#import "PublishBaseViewController.h"
#import "PublishDailiAdvantageViewController.h"

@interface PublishDailiViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ConfirmFooterViewDelegate, SelectCityViewControllerDelegate, PublishBaseViewControllerDelegate, PublishDailiAdvantageViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSArray *selectorArray;

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *direction;    //渠道
@property (nonatomic, copy) NSString *advantage;
@property (nonatomic, copy) NSString *durgclassificationid; //方向


@end
