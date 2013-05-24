//
//  AppDelegate.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBarController.h"

@class MBProgressHUD;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeveyTabBarController *tabController;
@property (nonatomic, copy)   NSString *uuid;
@property (nonatomic, copy)   NSString *userId;


- (void)showWithCustomAlertViewWithText:(NSString *)text andImageName:(NSString *)image;

@end
