//
//  ContactViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMenuView.h"
#import "Contact.h"
#import "TitleView.h"
#import "SelectCityViewController.h"

@interface ContactViewController : UIViewController
<UIScrollViewDelegate, MenuDelegate, TitleViewDelegate, UINavigationControllerDelegate, SelectCityViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (retain, nonatomic) SlideMenuView *mSlideMenu;
@property (retain, nonatomic) NSMutableArray *controllerArray;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, retain) UIPickerView *areaPicker;
@property (nonatomic, assign) BOOL pickerIsOn;

@property (nonatomic, retain) TitleView *titleView;

- (void)pushViewController:(UIViewController *)vc;

@end
