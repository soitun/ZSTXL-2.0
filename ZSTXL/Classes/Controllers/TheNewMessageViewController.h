//
//  TheNewMessageViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface TheNewMessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LoginViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;

@end
