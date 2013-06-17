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
//    self.title = @"收藏";
    self.dataSourceArray = [NSMutableArray array];
    self.view.backgroundColor = bgGreyColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.newsPage = 0;
    self.invPage = 0;
    self.maxrow = @"20";
    self.isNewsInfoOn = NO;
    
    [self requestInvStar];
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
    
    //segment control
    UISegmentedControl * navSeg = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"招商", @"资讯", nil]] autorelease];
    [navSeg addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    [navSeg setSegmentedControlStyle:UISegmentedControlStyleBar];
    self.navigationItem.titleView = navSeg;
    
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [self requestNewsStar];
    }
    else{
        [self requestInvStar];
    }
}

#pragma mark - request Data

- (void)requestNewsStar
{
    
}

- (void)requestInvStar
{
    NSString *page = [NSString stringWithFormat:@"%d", self.invPage];
    NSDictionary *para = @{@"path": @"getInvestmentCollectList.json",
                           @"userid": @"109971",
                           @"page": page,
                           @"maxrow": self.maxrow};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            NSArray *array = [json objForKey:@"InvestmentList"];
            for (NSDictionary *dict in array) {
                
                StarInvest *starInvest = [StarInvest createEntity];
                
                [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        [starInvest setValue:[obj stringValue] forKey:key];
                    }
                    else if ([obj isKindOfClass:[NSString class]]){
                        [starInvest setValue:obj forKey:key];
                    }
                }];
                [self.dataSourceArray addObject:starInvest];
            }
            
            self.invPage++;
            
            if (self.invPage == 1) {
                [self initTableFooter];
            }
            
            if ([self requestFinished]) {
                self.footer.titleLabel.text = @"加载完成";
            }
            else{
                self.footer.titleLabel.text = @"加载更多";
            }
            
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

- (void)parseNewsStar:(NSDictionary *)json
{
    
}

- (void)parseInvStar:(NSDictionary *)json
{
    
}

- (BOOL)requestFinished
{
    if (self.dataSourceArray.count == 0 || self.dataSourceArray.count % self.maxrow.integerValue != 0) {
        return YES;
    }
    return NO;
}

#pragma mark - table view

- (void)initTableFooter
{
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:self options:nil] lastObject];
    self.footer.delegate = self;
    self.tableView.tableFooterView = self.footer;
}

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
    
    if (self.isNewsInfoOn) {
        
    }
    else{
        StarInvest *starInvest = [self.dataSourceArray objectAtIndex:indexPath.row];
        infoCell.labTitle.text = starInvest.username;
        infoCell.labSubTitle.text = starInvest.productname;
        [infoCell.avatar setImageWithURL:[NSURL URLWithString:starInvest.investmentimgurl] placeholderImage:[UIImage imageNamed:@"agency_default.png"]];
    }
    
    
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

#pragma mark - footer delegate

- (void)LoadMoreFooterTap:(LoadMoreFooter *)footer
{
    if ([self requestFinished]) {
        return;
    }
    else{
        if (self.isNewsInfoOn) {
            [self requestNewsStar];
        }
        else{
            [self requestInvStar];
        }
    }
}

@end
