//
//  PharCategoryViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PharCategoryViewController.h"
#import "PharCategoryCell.h"
#import "SuspensionButton.h"
#import "PublishQueryViewController.h"

@interface PharCategoryViewController ()

@end

@implementation PharCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分类";
    self.navigationController.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initNavBar];
    SuspensionButton *susButton = [[SuspensionButton alloc] initWithFrame:CGRectMake(320-46, SCREEN_HEIGHT-64-50-20, 46, 50)];
    [susButton setTitle:@"发布" forState:UIControlStateNormal];
    [susButton addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:susButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - publish

- (void)publishAction
{
    DLog(@"publish zhaoshang");
    PublishQueryViewController *publishQueryVC = [[[PublishQueryViewController alloc] init] autorelease];
    [self.navigationController pushViewController:publishQueryVC animated:YES];
}


#pragma mark - navigation controller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:NSClassFromString(@"PharCategoryViewController")]
        || [viewController isKindOfClass:NSClassFromString(@"PublishQueryViewController")]) {
        [kAppDelegate.tabController hidesTabBar:YES animated:YES];
    }
    else{
        [kAppDelegate.tabController hidesTabBar:NO animated:YES];
    }
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
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"search_contact.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchContact:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
    [self.navigationItem setRightBarButtonItem:rBarButton];
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchContact:(UIButton *)sender
{
    
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataSource.count;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"PharCategoryCell";
    PharCategoryCell *cell = (PharCategoryCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PharCategoryCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%d", indexPath.row);
}

@end
