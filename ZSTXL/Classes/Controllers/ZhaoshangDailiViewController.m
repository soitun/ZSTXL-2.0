//
//  ZhaoshangDailiViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ZhaoshangDailiViewController.h"
#import "InformationCell.h"
#import "PharCategoryViewController.h"
#import "NewsDetailController.h"
#import "StarNewsInfo.h"
#import "NormalNewsInfo.h"

@interface ZhaoshangDailiViewController ()

@end

@implementation ZhaoshangDailiViewController

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
    self.title = @"招商代理";
    self.navigationController.delegate = self;
    
    self.page = 0;
    self.maxrow = @"20";
    self.dataSourceArray = [NSMutableArray array];
    self.tableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-49);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = bgGreyColor;
    
    [self initCateButton];
    [self initTableHeader];
    [self initEgoHeader];
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - ego refresh header

- (void)initEgoHeader
{
    self.egoView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
    self.egoView.delegate = self;
    [self.tableView addSubview:self.egoView];
    [self.egoView refreshLastUpdatedDate];
}

#pragma mark - ego delegate

- (void)doneLoading
{
    self.reloading = NO;
    [self.egoView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.egoView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.egoView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - ego delegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    self.reloading = YES;
//    [self performSelector:@selector(doneLoading) withObject:nil afterDelay:3.0];
    [self requestData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return self.reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}



#pragma mark - navigation delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:NSClassFromString(@"ZhaoshangDailiViewController")]) {
        [kAppDelegate.tabController hidesTabBar:NO animated:YES];
    }else{
        [kAppDelegate.tabController hidesTabBar:YES animated:YES];
    }
}



#pragma mark - get info

- (void)requestAdv
{
    NSDictionary *paraDict = @{@"path": @"getInformationMore.json"};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        
        [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
        if ([[GET_RETURNCODE(json) stringValue] isEqualToString:@"0"]) {
            
            NSArray *array = [json objForKey:@"InformationTopList"];
            if (array && [array count] > 0) {
                [(InfoAdvHeaderView *)self.tableView.tableHeaderView updateAdvData:array];
            }
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
    
}

- (void)requestData
{
    NSDictionary *paraDict = @{@"path": @"getInformation.json",
                               @"groupid": @"0",
                               @"page": [NSString stringWithFormat:@"%d", self.page],
                               @"maxrow": self.maxrow};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        
        [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            [self doneLoading];
            if (self.dataSourceArray.count > 0) {
                [self.dataSourceArray removeAllObjects];
            }
            [self.dataSourceArray addObjectsFromArray:[json objForKey:@"InformationList"]];
            [self saveNews];
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)showStarNews
{
    NSArray *tmpArray = [StarNewsInfo findAll];
    DLog(@"star array %@", tmpArray);
}

- (void)saveNews
{
    [NormalNewsInfo truncateAll];
    
    [self.dataSourceArray enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL *stop) {
        NormalNewsInfo * newsInfo = [NormalNewsInfo createEntity];
        [newsInfo initWithDict:dict];
        newsInfo.sortid = [NSString stringWithFormat:@"%d", idx];
    }];
    
    DB_SAVE();
}


#pragma mark - cate button

- (void)initCateButton
{
    self.CateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.CateButton.frame = CGRectMake(320-46, SCREEN_HEIGHT-64-49-50-5, 46, 50);
    [self.CateButton setBackgroundImage:[UIImage imageByName:@"sift"] forState:UIControlStateNormal];
    [self.CateButton setBackgroundImage:[UIImage imageByName:@"sift_p"] forState:UIControlStateHighlighted];
    [self.CateButton setTitle:@"分类" forState:UIControlStateNormal];
    [self.CateButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    self.CateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 4, 0);
    [self.CateButton addTarget:self action:@selector(category:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.CateButton];
    [self.view bringSubviewToFront:self.CateButton];
}

- (void)category:(UIButton *)sender
{
    PharCategoryViewController *pharCategoryVC = [[[PharCategoryViewController alloc] init] autorelease];
    [self.navigationController pushViewController:pharCategoryVC animated:YES];
}


#pragma mark - table view header

- (void)initTableHeader
{
    InfoAdvHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"InfoAdvHeaderView" owner:nil options:nil] lastObject];
    self.tableView.tableHeaderView = header;
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"InfomationCell";
    InformationCell *infoCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (infoCell == nil) {
        infoCell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:nil options:nil] lastObject];
    }
    infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    infoCell.labTitle.text = [dict objForKey:@"informationtitle"];
    infoCell.labSubTitle.text = [dict objForKey:@"informationtitle2"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objForKey:@"pictureurl"]]];
    [infoCell.avatar setImageWithURLRequest:urlRequest placeholderImage:[UIImage imageByName:@"agency_default"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        infoCell.avatar.image = image;
        NSString *url = [dict objForKey:@"pictureurl"];
        NSString *imageName = [[url componentsSeparatedByString:@"/"] lastObject];
        
        [Utility saveImage:image toDiskWithName:imageName];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"sortid == %d", indexPath.row];
        NewsInfo *newsInfo = [NewsInfo findFirstWithPredicate:pred];
        newsInfo.pictureurl = imageName;
        DB_SAVE();
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        DLog(@"%@", error);
    }];
    
    return infoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *infomationId = [dict objForKey:@"id"];
    NewsDetailController *newsDetailVC = [[[NewsDetailController alloc] init] autorelease];
    newsDetailVC.newsIndex = indexPath.row;
    newsDetailVC.newsId = infomationId;
    newsDetailVC.newsArray = self.dataSourceArray;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}


@end
