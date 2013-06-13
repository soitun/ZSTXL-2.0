//
//  AddMeViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCell.h"
#import "PopContactView.h"

@interface AddMeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ContactCellDelegate, PopContactViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (retain, nonatomic) IBOutlet UITableView *tableView;


@end
