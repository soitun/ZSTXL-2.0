//
//  MyHomePageViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileContactCell.h"
#import "MyProfileHeader.h"
#import "LoginViewController.h"
#import "MyInfo.h"
#import "SelectCityViewController.h"
#import "SelectPharViewController.h"
#import "SBTableAlert.h"

@interface MyProfileViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
MyProfileContactCellDelegate,
MyProfileHeaderDelegate,
LoginViewControllerDelegate,
UINavigationControllerDelegate,
SelectCityViewControllerDelegate,
SelectPharViewControllerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
SBTableAlertDataSource,
SBTableAlertDelegate
>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) MyProfileHeader *tableHeader;
@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSArray *selectorArray;
@property (nonatomic, retain) MyInfo *myInfo;
@property (nonatomic, retain) NSMutableArray *zdNameArray;
@property (nonatomic, retain) NSMutableDictionary *zdDict;
@property (nonatomic, retain) NSNumber *zdValue;
@property (nonatomic, retain) NSString *zdName;

@property (nonatomic, assign) BOOL updating;

@end
