//
//  StarNewsViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreFooter.h"
#import "SlideMenuView.h"
#import "StarNewsViewController.h"
#import "StarInvAgencyViewController.h"
#import "StarOtherInfoViewController.h"


@interface StarInfoViewController : UIViewController<MenuDelegate, UIScrollViewDelegate>

@property (retain, nonatomic) NSArray *menuItems;

@property (retain, nonatomic) SlideMenuView *mSlideMenu;
@property (retain, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (retain, nonatomic) NSMutableArray *controllerArray;

- (void)pushViewController:(UIViewController *)controller;


@end
