//
//  StarInvAgencyViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-18.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "CustomBaseTableViewController.h"

@interface StarInvAgencyViewController : CustomBaseTableViewController

@property (nonatomic, retain) UIViewController *parentController;

- (void)pushViewController:(UIViewController *)controller;

- (void)refreshAction;


@end
