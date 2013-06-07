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
    
    self.dataSource = [NSMutableArray array];
    self.tableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-49);
    [self initCateButton];
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
    NSDictionary *paraDict = nil;
    
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
    return 10;
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
    
    return infoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
