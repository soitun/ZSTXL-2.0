//
//  MainViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MainViewController.h"
#import "CustomNavigationController.h"
#import "TheNewMessageViewController.h"
#import "ContactViewController.h"
#import "ZhaoshangDailiViewController.h"
#import "MyProfileViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *controllerNameArray = @[@"TheNewMessageViewController", @"ContactViewController", @"ZhaoshangDailiViewController", @"MyProfileViewController"];
    NSArray *titleArray = @[@"最新消息", @"通讯录", @"招商代理", @"我的主页"];
    NSArray *tabBarImageArray = @[@"new_message", @"address_book", @"zsdl", @"my_profile"];
    NSArray *tabBarSelectedImageArray = @[@"new_message_p", @"address_book_p", @"zsdl_p", @"my_profile_p"];
    
    NSMutableArray *controllerArray = [[[NSMutableArray alloc] init] autorelease];
    int index = 0;
    for (NSString *controllerName in controllerNameArray) {
        Class controllerClass = NSClassFromString(controllerName);
        id controller = [[[controllerClass alloc] init] autorelease];
        CustomNavigationController *nav = [[[CustomNavigationController alloc] initWithRootViewController:controller] autorelease];
        [controllerArray addObject:nav];
        
        STabBarItem *tabBarItem=[[STabBarItem alloc] initWithFrame:CGRectMake(0, 0, 80, 55)];
        tabBarItem.itemIndex=index;
        [tabBarItem setTitle:[titleArray objectAtIndex:index] forState:UIControlStateNormal];
        tabBarItem.titleLabel.font = [UIFont systemFontOfSize:12];
        tabBarItem.titleLabel.textColor = [UIColor whiteColor];
        tabBarItem.normalImage = [UIImage imageNamed:[tabBarImageArray objectAtIndex:index]];
        tabBarItem.selectedImage = [UIImage imageNamed:[tabBarSelectedImageArray objectAtIndex:index]];
        [self.sTabBar addItem:tabBarItem];
        
        index++;
    }
    
    [self.sTabBar setSelectedItemAtIndex:0];
    self.sTabBar.backgoundImage = [UIImage imageNamed:@"toolbar.png"];
    [self setViewControllers:controllerArray];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
