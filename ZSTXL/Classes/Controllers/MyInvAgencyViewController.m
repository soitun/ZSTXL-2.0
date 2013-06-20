//
//  MyInvAgencyViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-15.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MyInvAgencyViewController.h"

@interface MyInvAgencyViewController ()

@end

@implementation MyInvAgencyViewController

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
    self.title = @"我的招商代理信息";
//    self.view.backgroundColor = bgGreyColor;
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.backgroundView = nil;
    
    self.page = 0;
    self.maxrow = @"20";
    self.dataSourceArray = [NSMutableArray array];
    [self initNavBar];
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

#pragma mark - request data

- (void)requestData
{
    NSString *page = [NSString stringWithFormat:@"%d", self.page];
    NSDictionary *para = @{@"path": @"getZsMyInvestAgencyList.json",
                           @"myuserid": @"109971",
                           @"page": page,
                           @"maxrow": self.maxrow};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        
        if (RETURNCODE_ISVALID(json)) {
            NSArray *array = [json objForKey:@"DataList"];
            [self.dataSourceArray addObjectsFromArray:array];
            self.page++;
            if (self.page == 1) {
                [self initTableFooter];
            }
            
            if ([self requestFinish]) {
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
    //还没定
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objForKey:@"productname"];
    cell.detailTextLabel.text = [dict objForKey:@"createtime"];
}

#pragma mark - footer delegate

- (void)LoadMoreFooterTap:(LoadMoreFooter *)footer
{
    if ([self requestFinish]) {
        self.footer.titleLabel.text = @"加载完成";
        return;
    }
    [footer.indicator startAnimating];
    [self requestData];
}

- (BOOL)requestFinish
{
    if (self.dataSourceArray.count == 0) {
        return YES;
    }else if(self.dataSourceArray.count % self.maxrow.intValue != 0){
        return YES;
    }
    
    return NO;
}

@end
