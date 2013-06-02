//
//  PublishBaseViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmFooterView.h"

@interface PublishBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ConfirmFooterViewDelegate>
@property (retain, nonatomic) UITableView *tableVeiw;

@property (nonatomic, retain) NSArray *titleArray;


@end
