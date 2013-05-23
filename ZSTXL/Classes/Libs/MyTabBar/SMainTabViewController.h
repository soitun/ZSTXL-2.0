//
//  SMainTabViewController.h
//  TestTabBar
//
//  Created by 玉玺 房 on 11-12-23.
//  Copyright (c) 2011年 Sohu All rights reserved.
//

/** 自定义的TabBarController **/

/** Tabbar隐藏的类型 **/
typedef enum _animationType
{
    TabBarHideAnimationNone,
    
    TabBarHideAnimationDown,
    
    TabBarHideAnimationFade
    
}TabBarHideAnimationType;

typedef enum _animationShowType
{
    TabBarShowAnimationNone,
    
    TabBarShowAnimationDown,
    
    TabBarShowAnimationFade
    
}TabBarShowAnimationType;


#import <UIKit/UIKit.h>
#import "STabBar.h"

@interface SMainTabViewController : UITabBarController<STabBarDelegate>
{
    STabBar *_sTabBar;
}

@property (nonatomic, retain) STabBar *sTabBar;
- (void) hideTabBarWithAnimationType:(TabBarHideAnimationType)type;
- (void) showTabWithAnimationType:(TabBarShowAnimationType)type;

- (void) setSelectIndex:(NSInteger)index;
- (void) setSelectController:(UIViewController *)controller;


@end