//
//  StarNewsViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "StarNewsViewController.h"
#import "InformationCell.h"
#import "StarNewsInfo.h"
#import "NewsDetailController.h"

@interface StarNewsViewController ()

@end

@implementation StarNewsViewController

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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self initNavBar];
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
    
    StarNewsInfo *newsInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
    infoCell.labTitle.text = newsInfo.title;
    infoCell.labSubTitle.text = newsInfo.subtitle;
    infoCell.avatar.image = [Utility readImageFromDisk:newsInfo.pictureurl];
    
    return infoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StarNewsInfo *chooseNewsInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSMutableArray *newsArray = [NSMutableArray array];
    [self.dataSourceArray enumerateObjectsUsingBlock:^(StarNewsInfo *newsInfo, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = [newsInfo toDict];
        [newsArray addObject:dict];
    }];
    
    NewsDetailController *newsDetailVC = [[[NewsDetailController alloc] init] autorelease];
    newsDetailVC.newsIndex = indexPath.row;
    newsDetailVC.newsId = chooseNewsInfo.newsid;
    newsDetailVC.newsArray = newsArray;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
    
}

@end
