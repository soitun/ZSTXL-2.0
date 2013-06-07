//
//  SelectViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableAlert.h"
#import "MyInfo.h"
#import "ShaixuanPharViewController.h"

@interface SelectViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, SBTableAlertDataSource, SBTableAlertDelegate, UIAlertViewDelegate, ShaixuanPharViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *leftArray;
@property (nonatomic, retain) NSString *zsdl;
@property (nonatomic, assign) NSInteger zdKind;
@property (nonatomic, retain) NSArray *zdNameArray;
@property (nonatomic, retain) NSMutableDictionary *zdDict;
@property (nonatomic, retain) NSNumber *zdValue;
@property (nonatomic, retain) NSMutableArray *pharArray;
@property (nonatomic, copy) NSString *pharId;
@property (nonatomic, copy) NSString *pharContent;

- (IBAction)confirm:(UIButton *)sender;


@end
