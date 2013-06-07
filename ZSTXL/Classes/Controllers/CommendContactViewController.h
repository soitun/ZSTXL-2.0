//
//  CommendContactViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopContactView.h"
#import "ContactCell.h"

@interface CommendContactViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PopContactViewDelegate, ContactCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *commendContactArray;
@property (retain, nonatomic) UIViewController *parentController;
@property (assign, nonatomic) BOOL getContactFinsh;

- (void)refreshAction;

@end
