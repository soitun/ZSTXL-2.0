//
//  SearchInvAgencyViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SearchInvAgencyViewController.h"
#import "ZhaoshangPharListCell.h"
#import "ZhaoshangInfoViewController.h"
#import "LoadMoreFooter.h"

@interface SearchInvAgencyViewController ()

@end

@implementation SearchInvAgencyViewController

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
    self.title = @"搜索招商代理信息";
    self.dataSourceArray = [NSMutableArray array];
    self.page = 0;
    self.maxrow = @"20";
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.view.backgroundColor = bgGreyColor;
    
    [self initSearchBar];
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_searchBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

#pragma mark - search bar

- (void)initSearchBar
{
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"search_bar_texture"]];
    [self.searchBar setTranslucent:YES];
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

#pragma mark - request Data

- (void)requestData
{
    NSString *page = [NSString stringWithFormat:@"%d", self.page];
    NSDictionary *para = @{@"path": @"getZsSerchInvestAgencyList.json",
                           @"key": self.searchKey,
                           @"page": page,
                           @"maxrow": self.maxrow,
                           @"proviceid": [PersistenceHelper dataForKey:kProvinceId],
                           @"cityid": [PersistenceHelper dataForKey:kCityId]};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        DLog(@"json %@", json);
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            NSArray *array = [json objForKey:@"DataList"];
            
            if (self.page == 0) {
                [self initTableFooter];
            }
            
            if ([self requestFinished]) {
                if (self.page == 0) {
                    self.page++;
                }
                self.footer.titleLabel.text = @"加载完成";
            }
            else{
                self.page++;
                self.footer.titleLabel.text = @"加载更多";
            }
            
            
            [self.dataSourceArray addObjectsFromArray:array];
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

- (BOOL)requestFinished
{
    if (self.dataSourceArray.count == 0 || self.dataSourceArray.count % self.maxrow.intValue != 0) {
        return YES;
    }
    return NO;
}

#pragma mark - searchbar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchKey = searchBar.text;
    [searchBar resignFirstResponder];
    [self requestData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""]) {
        [self resetDataSource];
    }
}

- (void)resetDataSource
{
    [self.dataSourceArray removeAllObjects];
    [self.tableView reloadData];
    self.tableView.tableFooterView = nil;
    self.page = 0;
}

#pragma mark - table view

- (void)initTableFooter
{
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:self options:nil] lastObject];
    self.footer.delegate = self;
    self.tableView.tableFooterView = self.footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objForKey:@"investmentimgurl"]]];
    
    [cell.pharImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"img_zs"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.pharImage.image = image;
        [Utility addBorderView:cell.pharImage withColor:RGBCOLOR(189, 190, 190) width:1];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        DLog(@"error %@", error);
    }];
    
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
    [self requestData];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


@end
