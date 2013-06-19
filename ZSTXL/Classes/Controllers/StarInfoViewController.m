//
//  StarNewsViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "StarInfoViewController.h"
#import "InformationCell.h"
#import "StarNewsInfo.h"
#import "NewsDetailController.h"
#import "StarNews.h"
#import "StarInvest.h"

@interface StarInfoViewController ()

@end

@implementation StarInfoViewController

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
    
    self.title = @"收藏";
    self.view.backgroundColor = bgGreyColor;
    
    [self initNavBar];
    [self initSlideView];
    [self initScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - init scrollview

- (void)initScrollView
{
    self.mScrollView.contentOffset = CGPointMake(0, 0);
    self.mScrollView.contentSize = CGSizeMake(320*3, self.mScrollView.frame.size.height);
    
    self.controllerArray = [NSMutableArray arrayWithCapacity:3];
    //招商/代理， 咨询 其他
    StarInvAgencyViewController *starInvAgencyVC = [[[StarInvAgencyViewController alloc] init] autorelease];
    starInvAgencyVC.parentController = self;
    starInvAgencyVC.view.frame = CGRectMake(0, 0, 320, self.mScrollView.frame.size.height);
    [self.mScrollView addSubview:starInvAgencyVC.view];
    [self.controllerArray addObject:starInvAgencyVC];
    
    
    StarNewsViewController *starNewsVC = [[[StarNewsViewController alloc] init] autorelease];
    starNewsVC.parentController = self;
    starNewsVC.view.frame = CGRectMake(320, 0, 320, self.mScrollView.frame.size.height);
    [self.mScrollView addSubview:starNewsVC.view];
    [self.controllerArray addObject:starNewsVC];

    StarOtherInfoViewController *starOtherInfoVC = [[[StarOtherInfoViewController alloc] init] autorelease];
    starOtherInfoVC.parentController = self;
    starOtherInfoVC.view.frame = CGRectMake(320*2, 0, 320, self.mScrollView.frame.size.height);
    [self.mScrollView addSubview:starOtherInfoVC.view];
    [self.controllerArray addObject:starOtherInfoVC];
}

#pragma mark - slide bar

- (void)initSlideView
{
    self.menuItems = [NSArray arrayWithObjects:@"招商/代理", @"资讯", @"其他", nil];
    self.mSlideMenu = [[[SlideMenuView alloc] initWithItemsArray:self.menuItems] autorelease];
    self.mSlideMenu.frame = CGRectMake(0, 0, 320, 34);
    self.mSlideMenu.delegate = self;
    [self.view addSubview:self.mSlideMenu];
    [Utility addShadow:self.mSlideMenu];
}

- (void)menu:(MenuControlView *)menu clickedAtIndex:(NSInteger)index
{
    [self.mScrollView setContentOffset:CGPointMake(index*320, 0) animated:YES];
    
//    [self switchTitleView:index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currPage = scrollView.contentOffset.x/320;
    
//    [self switchTitleView:currPage];
    
    [self.mSlideMenu slideBgToIndex:currPage];
    [self refreshPageAtIndex:currPage];
}

- (void)refreshPageAtIndex:(NSInteger)pageIndex {
    UIViewController *controller = [self.controllerArray objectAtIndex:pageIndex];
    if ([controller respondsToSelector:@selector(refreshAction)]) {
        [controller performSelector:@selector(refreshAction)];
    }
}

- (void)switchTitleView:(NSInteger)index
{
    self.title = [self.menuItems objectAtIndex:index];
}

#pragma mark - nav bar

- (void)initNavBar
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - push

- (void)pushViewController:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
}

@end
