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

@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *contentArray;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSDictionary *contactInfo;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) ZSInfoHeader *header;
@property (nonatomic, retain) ZSInfoContactView *contactView;

@end
