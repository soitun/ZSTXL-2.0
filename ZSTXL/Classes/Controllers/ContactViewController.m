//
//  ContactViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ContactViewController.h"
#import "FriendContactViewController.h"
#import "AllContactViewController.h"
#import "CommendContactViewController.h"
#import "CityTitleView.h"
#import "SelectViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.view.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityName = @"北京";
    
    [self initAreaPickerView];
    [self initTitleView];
    [self initSlideView];
    [self initScrollView];
}

- (void)initAreaPickerView
{
    
}

- (void)initTitleView
{
    UIView *titleView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 44)] autorelease];
    titleView.backgroundColor = [UIColor clearColor];
    CGSize titleSize = [self.cityName sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:CGSizeMake(200, 44)];
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
    titleLabel.center = CGPointMake(titleView.center.x-4, titleView.center.y);
    titleLabel.frame = CGRectIntegral(titleLabel.frame);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.cityName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleView addSubview:titleLabel];
    
    CGFloat x = titleLabel.frame.origin.x + titleLabel.frame.size.width;
    UIImageView *areaAngle = [[UIImageView alloc] initWithFrame:CGRectMake(x, 30, 9, 6)];
    areaAngle.image = [UIImage imageNamed:@"area_angle"];
    [titleView addSubview:areaAngle];
    
    self.navigationItem.titleView = titleView;
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCity:)] autorelease];
    [titleView addGestureRecognizer:tap];
}

- (void)changeCity:(UITapGestureRecognizer *)tap
{
    DLog(@"change city");
}

- (void)initSlideView
{
    NSArray *menuItems = [NSArray arrayWithObjects:@"好友", @"推荐", @"全部", nil];
    self.mSlideMenu = [[[SlideMenuView alloc] initWithItemsArray:menuItems] autorelease];
    self.mSlideMenu.frame = CGRectMake(0, 0, 320, 34);
    self.mSlideMenu.delegate = self;
    [self.view addSubview:self.mSlideMenu];
//    [Utility addShadow:self.mSlideMenu];
}

- (void)initScrollView
{
    self.mScrollView.frame = CGRectMake(0, 34, 320, SCREEN_HEIGHT-64-34-49);
    self.mScrollView.bounces = NO;
    self.mScrollView.contentOffset = CGPointMake(0, 0);
    self.mScrollView.contentSize = CGSizeMake(320*3, self.mScrollView.frame.size.height-55);
    self.controllerArray = [NSMutableArray arrayWithCapacity:3];
    //好友 推荐 全部
    FriendContactViewController *friendVC = [[[FriendContactViewController alloc] init] autorelease];
    friendVC.parentController = self;
    friendVC.view.frame = CGRectMake(0, 0, 320, self.mScrollView.frame.size.height);
    [self.mScrollView addSubview:friendVC.view];
    [self.controllerArray addObject:friendVC];
    
    
    CommendContactViewController *commendVC = [[[CommendContactViewController alloc] init] autorelease];
    commendVC.parentController = self;
    commendVC.view.frame = CGRectMake(320, 0, 320, self.mScrollView.frame.size.height);
    [self.mScrollView addSubview:commendVC.view];
    [self.controllerArray addObject:commendVC];
    
    AllContactViewController *allVC = [[[AllContactViewController alloc] init] autorelease];
    allVC.parentController = self;
    allVC.view.frame = CGRectMake(320*2, 0, 320, self.mScrollView.frame.size.height);
    [self.mScrollView addSubview:allVC.view];
    
    UIButton *siftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [siftButton setBackgroundImage:[UIImage imageNamed:@"sift"] forState:UIControlStateNormal];
    [siftButton setBackgroundImage:[UIImage imageNamed:@"sift_p"] forState:UIControlStateHighlighted];
    [siftButton setTitle:@"筛选" forState:UIControlStateNormal];
    [siftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [siftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [siftButton addTarget:self action:@selector(sift) forControlEvents:UIControlEventTouchUpInside];
    siftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    siftButton.frame = CGRectMake(320-37, allVC.view.frame.size.height-35, 37, 32);
    [allVC.view addSubview:siftButton];
    [allVC.view bringSubviewToFront:siftButton];
    [self.controllerArray addObject:allVC];
}


#pragma mark - tslocation delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        DLog(@"取消");
        self.pickerIsOn = NO;
    }
    else{
        DLog(@"确定");
    }
}


#pragma mark - menu delegate

- (void)menu:(MenuControlView *)menu clickedAtIndex:(NSInteger)index
{
    [self.mScrollView setContentOffset:CGPointMake(index*320, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currPage = scrollView.contentOffset.x/320;
    [self.mSlideMenu slideBgToIndex:currPage];
    [self refreshPageAtIndex:currPage];
}

- (void)refreshPageAtIndex:(NSInteger)pageIndex {
    UIViewController *controller = [self.controllerArray objectAtIndex:pageIndex];
    if ([controller respondsToSelector:@selector(refreshAction)]) {
        [controller performSelector:@selector(refreshAction)];
    }
}

#pragma mark - push

- (void)pushViewController:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - sift

- (void)sift
{
    DLog(@"筛选");
    SelectViewController *selectVC = [[[SelectViewController alloc] init] autorelease];
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMScrollView:nil];
    [super viewDidUnload];
}
@end
