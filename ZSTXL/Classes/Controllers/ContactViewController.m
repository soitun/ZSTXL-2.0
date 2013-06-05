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
#import "SearchContactViewController.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    [self resetNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.view.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityName = @"北京";
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"search_contact.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchContact:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
    [self.navigationItem setRightBarButtonItem:rBarButton];
    
    
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
    TitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:nil options:nil] lastObject];
    titleView.title = @"北京";
    titleView.delegate = self;
    self.navigationItem.titleView = titleView;
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
    [Utility addShadow:self.mSlideMenu];
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
    [siftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [siftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [siftButton addTarget:self action:@selector(sift) forControlEvents:UIControlEventTouchUpInside];
    siftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 3, 0);
    siftButton.frame = CGRectMake(320-46, allVC.view.frame.size.height-35-20, 46, 50);
    [allVC.view addSubview:siftButton];
    [allVC.view bringSubviewToFront:siftButton];
    [self.controllerArray addObject:allVC];
}

#pragma mark - nav bar

- (void)resetNavigationBar {
    if (self.navigationController.navigationBar.frame.origin.y != 0) {
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
    }
}

- (void)searchContact:(UIButton *)sender
{
    SearchContactViewController *searchContactVC = [[[SearchContactViewController alloc] init] autorelease];
    [self.navigationController pushViewController:searchContactVC animated:YES];
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
