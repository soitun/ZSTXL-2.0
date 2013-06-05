//
//  AppDelegate.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

#import "CustomNavigationController.h"
#import "TheNewMessageViewController.h"
#import "ContactViewController.h"
#import "ZhaoshangDailiViewController.h"
#import "MyProfileViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    //DB
    [MagicalRecord setupCoreDataStack];
    self.uuid = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
    //判断网络
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.boracloud.com"];
    if (self.isGpsError) {
        self.theNewCity = @"北京";
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        [reach startNotifier];
    }
    
    //gps
    self.geocoder = [[[CLGeocoder alloc] init] autorelease];
    [self initGPS];
    
    
    [self initTabController];
    self.window.rootViewController = self.tabController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initTabController
{
    NSArray *controllerNameArray = @[@"TheNewMessageViewController", @"ContactViewController", @"ZhaoshangDailiViewController", @"MyProfileViewController"];
    NSArray *titleArray = @[@"最新消息", @"通讯录", @"招商代理", @"我的主页"];
    NSArray *tabBarImageArray = @[@"new_message", @"address_book", @"zsdl", @"my_profile"];
    NSArray *tabBarSelectedImageArray = @[@"new_message_p", @"address_book_p", @"zsdl_p", @"my_profile_p"];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    NSMutableArray *controllerArray = [[[NSMutableArray alloc] init] autorelease];
    int index = 0;
    for (NSString *controllerName in controllerNameArray) {
        Class controllerClass = NSClassFromString(controllerName);
        UIViewController *controller = [[[controllerClass alloc] init] autorelease];
        CustomNavigationController *nav = [[[CustomNavigationController alloc] initWithRootViewController:controller] autorelease];
        [controllerArray addObject:nav];
        
        NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
        [imageDict setObject:[UIImage imageNamed:[tabBarImageArray objectAtIndex:index]] forKey:@"Default"];
        [imageDict setObject:[UIImage imageNamed:[tabBarSelectedImageArray objectAtIndex:index]] forKey:@"Highlighted"];
        [imageDict setObject:[UIImage imageNamed:[tabBarSelectedImageArray objectAtIndex:index]] forKey:@"Selected"];
        [imageDict setObject:[UIImage imageNamed:[tabBarSelectedImageArray objectAtIndex:index]] forKey:@"Selected|Highlighted"];
        
        [imageArray addObject:imageDict];

        index++;
    }
    
    self.tabController = [[LeveyTabBarController alloc] initWithViewControllers:controllerArray imageArray:imageArray titleArray:titleArray];
    [self.tabController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar"]];
    self.tabController.tabBarTransparent = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

#pragma mark - network reachbility

- (void)reachabilityChanged:(NSNotification *)noti
{
    Reachability * reach = [noti object];
    
    if([reach isReachable])
    {
        [self getCurrentCity];
        DLog(@"new city %@", self.theNewCity);
        NSLog(@"网络可行");
    }
    else
    {
        NSLog(@"网络不可行");
        [self showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }
}


#pragma mark - geo

- (void)initGPS {
    if(self.locationManager == nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.f;
	}
    if ([CLLocationManager locationServicesEnabled]   &&   [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [self.locationManager startUpdatingLocation];
        self.isGpsError = NO;
    }
    else{
        self.isGpsError = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请在系统设置中打开“定位服务”来允许“招商代理通讯录”确定您的位置"
                                                       delegate:nil cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)getCurrentCity  //有网的时候
{
    __block NSString *city = nil;
    [self.geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        city = [placemark performSelector:NSSelectorFromString(@"administrativeArea")];
        city = [city substringToIndex:[city length] -1];
        if ([city isValid]) {
            self.theNewCity = city;
        }
        else{
            self.theNewCity = @"北京";
        }
    }];
}

#pragma mark - location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"location manager AuthorizationStatus: %d", status);
}

- (NSString *)userId
{
    NSString *userIdTmp = [PersistenceHelper dataForKey:kUserId];
    if (![userIdTmp isValid]) {
        return @"0";
    }
    return userIdTmp;
}

#pragma mark - show alert

- (void)showWithCustomAlertViewWithText:(NSString *)text andImageName:(NSString *)image {
	
    if (HUD && HUD.superview) {
        
        if ([text isEqualToString:kNetworkError]) {
            //当网络出问题时，不要不停的提示
            return;
        }
        
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    
    [self doShowAlertWithText:text imageByName:image];
}

- (void)doShowAlertWithText:(NSString *)text imageByName:(NSString *)image {
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
	[self.window addSubview:HUD];
	
    if (image && [image length] > 0) {
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageByName:image]] autorelease];
    } else {
        HUD.customView = nil;
    }
	
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
	HUD.userInteractionEnabled = NO;
    HUD.labelText = text ? text : @"出错了";
	
    [HUD show:YES];
	[HUD hide:YES afterDelay:2];
}

@end
