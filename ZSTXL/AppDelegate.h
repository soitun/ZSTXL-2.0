//
//  AppDelegate.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LeveyTabBarController.h"

@class MBProgressHUD;
@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeveyTabBarController *tabController;
@property (nonatomic, copy)   NSString *uuid;
@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLGeocoder *geocoder;
@property (nonatomic, assign) BOOL isGpsError;
@property (nonatomic, copy) NSString *theNewCity;


- (void)showWithCustomAlertViewWithText:(NSString *)text andImageName:(NSString *)image;

@end
