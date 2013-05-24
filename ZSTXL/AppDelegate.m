//
//  AppDelegate.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "AppDelegate.h"

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

    [MagicalRecord setupCoreDataStack];
    self.uuid = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
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

- (NSString *)userId
{
    NSString *userIdTmp = [PersistenceHelper dataForKey:kUserId];
    if (![userIdTmp isValid]) {
        return @"0";
    }
    return userIdTmp;
}

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
