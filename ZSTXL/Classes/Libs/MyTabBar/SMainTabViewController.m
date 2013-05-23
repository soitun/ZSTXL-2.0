//
//  SMainTabViewController.m
//  TestTabBar
//
//  Created by 玉玺 房 on 11-12-23.
//  Copyright (c) 2011年 Sohu All rights reserved.
//

#define TAB_BAR_HEIGHT 55
#import "SMainTabViewController.h"

@implementation SMainTabViewController

@synthesize sTabBar = _sTabBar;

#pragma mark init & dealloc
#pragma ---

- (void)dealloc
{
    self.sTabBar = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
#pragma ---

- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏系统的tabbar
    UITabBar* tabBar = (UITabBar*)[[self.view subviews] objectAtIndex:1];
    tabBar.frame = CGRectZero;
    
    STabBar* sTabBar = [[[STabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-TAB_BAR_HEIGHT, 320, TAB_BAR_HEIGHT)] autorelease];
    self.sTabBar = sTabBar;
    sTabBar.delegate = self;
    [self.view addSubview:self.sTabBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) shouldAutorotate
{
    return NO;
}

#pragma mark sTabBarDelegate
#pragma ---

- (void) sTabBarItemSelectedAtIndex:(NSInteger)index
{
//    NSLog(@"%@",self.sTabBar.items objectAtIndex:index);
    
    /** 调用系统的代理 **/
    if ([(NSObject*)self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) 
    {
        if (![self.delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            return;
        }
    }
    ///***liu**//放到这里
    STabBarItem *item = [self.sTabBar.items objectAtIndex:index];
    [item setSelected:YES];
    /** 把其他按钮取消选中 **/
    for (STabBarItem* theItem in self.sTabBar.items)
    {
        if (item != theItem)
        {
            [theItem setSelected:NO];
        }
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self.sTabBar.selectBGImgV setFrame:CGRectMake(item.frame.origin.x, self.sTabBar.selectBGImgV.frame.origin.y, self.sTabBar.selectBGImgV.frame.size.width, self.sTabBar.selectBGImgV.frame.size.height)];
    [UIView commitAnimations];
    //*/
    [self setSelectedIndex:index];
    if([(NSObject*)self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [self.delegate tabBarController:self didSelectViewController:[self.viewControllers objectAtIndex:index]];
    }
}

#pragma mark public method
#pragma ---

//- (void) setSelectIndex:(NSInteger)index
//{
//    NSLog(@"%d",index);
//    [self sTabBarItemSelectedAtIndex:index];
//    
//    /** 使sTabBarItem选中 **/
//    [self.sTabBar setSelectedItemAtIndex:index];
//}

//- (void) setSelectController:(UIViewController *)thecontroller
//{
//    for (NSInteger index = 0; index < [self.viewControllers count]; ++index)
//    {
//        UIViewController* controller = [self.viewControllers objectAtIndex:index];
//        if (controller == thecontroller)
//        {
//            [self sTabBarItemSelectedAtIndex:index];
//            return;
//        }
//    }
//}

- (void) hideTabBarWithAnimationType:(TabBarHideAnimationType)type
{
    if (type == TabBarHideAnimationNone)
    {
        self.sTabBar.hidden = YES;
    }
    else if (type == TabBarHideAnimationDown)
    {
        [UIView beginAnimations:@"TabBarHide" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        self.sTabBar.frame = CGRectMake(0, self.view.frame.size.height, 320, TAB_BAR_HEIGHT);
        [UIView commitAnimations];
    }
    else if (type == TabBarHideAnimationFade)
    {
        [UIView beginAnimations:@"TabBarHide" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        self.sTabBar.alpha = 0;
        [UIView commitAnimations];
    }
}

- (void)showTabWithAnimationType:(TabBarShowAnimationType)type
{
    if (type == TabBarShowAnimationNone)
    {
        self.sTabBar.hidden = NO;
        self.sTabBar.frame = CGRectMake(0, self.view.frame.size.height - TAB_BAR_HEIGHT, 320, TAB_BAR_HEIGHT);
    }
    else if (type == TabBarShowAnimationDown)
    {
        [UIView beginAnimations:@"TabBarShow" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        self.sTabBar.frame = CGRectMake(0, self.view.frame.size.height - TAB_BAR_HEIGHT, 320, TAB_BAR_HEIGHT);
        [UIView commitAnimations];
    }
    else if (type == TabBarShowAnimationFade)
    {
        [UIView beginAnimations:@"TabBarShow" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        self.sTabBar.alpha = 1;
        [UIView commitAnimations];
    }
}

@end




