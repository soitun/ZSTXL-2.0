//
//  MyInvAgencyViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-15.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MyInvAgencyViewController.h"
#import "ZhaoshangPharListCell.h"
#import "ZhaoshangInfoViewController.h"

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
    self.view.backgroundColor = bgGreyColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
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
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ZhaoshangPharListCell";
    ZhaoshangPharListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZhaoshangPharListCell" owner:self options:nil] lastObject];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ZhaoshangPharListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *type = [[dict objForKey:@"type"] stringValue];
    
    if ([type isEqualToString:@"1"]) {
        cell.zsdlBaseImage.image = [UIImage imageNamed:@"img_zhaoshang"];
        cell.zsdlLabel.text = @"招商";
        
    }
    else{
        cell.zsdlBaseImage.image = [UIImage imageNamed:@"img_daili"];
        cell.zsdlLabel.text = @"代理";
    }
    
    cell.pharNameLabel.text = [dict objForKey:@"productname"];
    cell.companyNameLabel.text = [dict objForKey:@"companyname"];
    cell.areaLabel.text = [dict objForKey:@"placename"];
    cell.usernameLabel.text = [dict objForKey:@"username"];
    
    [cell.pharImage setImageWithURL:[NSURL URLWithString:@"investmentimgurl"] placeholderImage:[UIImage imageNamed:@"img_zs"]];
    
    NSString *isMember = [[dict objForKey:@"ismember"] stringValue];
    if ([isMember isEqualToString:@"1"]) {
        cell.xunImage.hidden = NO;
    }
    else{
        cell.xunImage.hidden = YES;
    }
    
    NSString *isVip = [[dict objForKey:@"isVip"] stringValue];
    if ([isVip isEqualToString:@"1"]) {
        cell.xunVImage.hidden = NO;
    }
    else{
        cell.xunImage.hidden = YES;
    }
    
    NSString *creditlevel = [dict objForKey:@"creditlevel"];
    
    if ([creditlevel isEqualToString:@"无信用评级"]) {
        cell.xunBImage.hidden = YES;
    }
    else{
        cell.xunBImage.hidden = NO;
        cell.xunBImage.image = [UIImage imageNamed:@"creditlevel"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DLog(@"grage %@", [dict objForKey:@"creditlevel"]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    ZhaoshangInfoViewController *zhaoshangInfoVC = [[[ZhaoshangInfoViewController alloc] init] autorelease];
    zhaoshangInfoVC.investmentId = [dict objForKey:@"investmentid"];
    [self.navigationController pushViewController:zhaoshangInfoVC animated:YES];
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
