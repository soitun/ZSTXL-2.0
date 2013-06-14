//
//  ZhaoshangInfoViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSInfoHeader.h"
#import "ZSInfoContactView.h"

@interface ZhaoshangInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ZSInfoHeaderDelegate, ZSInfoContactViewDelegate>


@property (nonatomic, copy) NSString *investmentId;
@property (nonatomic, copy) NSString *userId;   //暂无用


@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) NSArray *keyArray;
//@property (nonatomic, retain) NSDictionary *userInfo;
//@property (nonatomic, retain) NSDictionary *contactInfo;

@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) ZSInfoHeader *header;
@property (nonatomic, retain) ZSInfoContactView *contactView;

@property (nonatomic, assign) BOOL isStar;

@end
