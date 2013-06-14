//
//  PharCategoryViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PharCategoryViewController.h"
#import "SuspensionButton.h"
#import "PublishQueryViewController.h"
#import "PublishDailiViewController.h"
#import "PublishView.h"
#import "ZhaoshangInfoViewController.h"
#import "InvestmentInfo.h"

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

//- (void)viewWillAppear:(BOOL)animated
//{
//    [kAppDelegate.tabController hidesTabBar:YES animated:YES];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分类";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSourceArray = [NSMutableArray array];
    
    [self initNavBar];
    [self initPublishButton];
    [self requestData];

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

#pragma mark - publis button

- (void)initPublishButton
{
    SuspensionButton *susButton = [[SuspensionButton alloc] initWithFrame:CGRectMake(320-46, SCREEN_HEIGHT-64-50-20, 46, 50)];
    [susButton setTitle:@"发布" forState:UIControlStateNormal];
    [susButton addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:susButton];
}

#pragma mark - publish

- (void)publishAction
{
    PublishView *view = [[[NSBundle mainBundle] loadNibNamed:@"PublishView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(31, 180, 258, 203);
    view.delegate = self;
    self.bgControl = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)] autorelease];
    self.bgControl.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
    [self.bgControl addSubview:view];
    [self.bgControl addTarget:self action:@selector(removeBgControl) forControlEvents:UIControlEventTouchDown];
    
    [kAppDelegate.window addSubview:self.bgControl];

}

- (void)publishViewZhaoshang
{
    DLog(@"publish zhaoshang");
    [self.bgControl removeFromSuperview];
    PublishQueryViewController *publishQueryVC = [[[PublishQueryViewController alloc] init] autorelease];
    [self.navigationController pushViewController:publishQueryVC animated:YES];
}

- (void)publishViewDaili
{
    [self.bgControl removeFromSuperview];
    PublishDailiViewController *publishDailiVC = [[[PublishDailiViewController alloc] init] autorelease];
    [self.navigationController pushViewController:publishDailiVC animated:YES];
}

- (void)publishViewCancel
{
    [self.bgControl removeFromSuperview];
}

- (void)removeBgControl
{
    [self.bgControl removeFromSuperview];
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
//    [kAppDelegate.tabController hidesTabBar:NO animated:YES];
}

- (void)searchContact:(UIButton *)sender
{
    
}

#pragma mark - request Data

- (void)requestData
{
    NSDictionary *para = @{@"path": @"getInvestmentClassify.json",
                           @"userid": kAppDelegate.userId,
                           @"provinceid": [PersistenceHelper dataForKey:kProvinceId],
                           @"cityid": [PersistenceHelper dataForKey:kCityId]};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        DLog(@"%@", json);
        if (RETURNCODE_ISVALID(json)) {
            [self parseData:json];
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)parseData:(NSDictionary *)json
{
    NSArray *array = [json objForKey:@"InvestmentInfo"];
    for (NSDictionary *dict in array) {
        if ([dict isEqual:[NSNull null]]) {
            continue;
        }
        
        InvestmentInfo *investmentInfo = [InvestmentInfo createEntity];
        investmentInfo.infoid = [[dict objForKey:@"id"] stringValue];
        investmentInfo.content = [dict objForKey:@"content"];
        investmentInfo.investment = [dict objForKey:@"investment"];
        investmentInfo.picturelinkurl = [dict objForKey:@"picturelinkurl"];
        investmentInfo.col4 = [[dict objForKey:@"col4"] stringValue];
        investmentInfo.stime = [dict objForKey:@"stime"];
        [self.dataSourceArray addObject:investmentInfo];
    }
    
    DB_SAVE();
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
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"PharCategoryCell";
    PharCategoryCell *cell = (PharCategoryCell *)[tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PharCategoryCell" owner:nil options:nil] lastObject];
    }
    [self configureCell:cell atIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)configureCell:(PharCategoryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    InvestmentInfo *info = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = info.content;
    cell.detailLabel.text = info.investment;
    [cell.pharImage setImageWithURL:[NSURL URLWithString:info.picturelinkurl] placeholderImage:[UIImage imageNamed:@""]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)pharCategotyCellTap
{
    ZhaoshangInfoViewController *zhaoshangInfoVC = [[[ZhaoshangInfoViewController alloc] init] autorelease];
    [self.navigationController pushViewController:zhaoshangInfoVC animated:YES];
}

@end
