//
//  FriendContactViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopContactView.h"
#import "ContactCell.h"
#import "OtherHomepageViewController.h"

@interface FriendContactViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, PopContactViewDelegate, ContactCellDelegate, OtherHomepageVCDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) NSMutableDictionary *contactDict;
@property (nonatomic, retain) NSMutableArray *sectionArray;

@property (nonatomic, retain) UIViewController *parentController;

- (void)refreshAction;

@end
