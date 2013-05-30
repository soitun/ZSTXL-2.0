//
//  SearchContactViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SearchContactViewController.h"
#import "ContactCell.h"
#import "LoadMoreCell.h"
#import "SearchContact.h"
#import "LoadMoreFooter.h"

@interface SearchContactViewController ()

@end

@implementation SearchContactViewController

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
    self.title = @"搜索";
    self.page = 0;
    self.maxrow = @"20";
    self.dataSource = [NSMutableArray array];
    
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_searchBar release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSearchBar:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [kAppDelegate.tabController hidesTabBar:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [kAppDelegate.tabController hidesTabBar:NO animated:YES];
}


#pragma mark - table view

- (void)initTableFooter
{
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:nil options:nil] lastObject];
    self.footer.titleLabel.text = @"加载更多";
    self.footer.delegate = self;
    self.tableView.tableFooterView = self.footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ContactCell";

    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:nil options:nil] lastObject];
    }
    
    SearchContact *contact = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = contact.username;
    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)LoadMoreFooterTap
{
    if ([self finishLoad]) {
        return;
    }
    else{
        [self getSearchUser:self.searchBar.text];
    }
}

#pragma mark - search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    DLog(@"searchText %@", searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"search");
    [searchBar resignFirstResponder];
    [self getSearchUser:searchBar.text];
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    DLog(@"cancel search");
//    [self.dataSource removeAllObjects];
//    [self.tableView reloadData];
//    self.tableView.tableFooterView = nil;
//}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if ([searchBar.text isEqualToString:@""]) {

        [self resetDataSource];
    }
}

- (void)resetDataSource
{
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    self.tableView.tableFooterView = nil;
    self.page = 0;
}

#pragma mark - search action

- (void)getSearchUser:(NSString *)searchText
{
    NSLog(@"search clicked!!!!!!!!!");
    
    ///getZsUserByName.json, userid, proviceid, cityid, name
    
    NSDictionary *paraDict = @{@"path": @"getZsUserByName.json",
                               @"userid": kAppDelegate.userId,
                               @"page": [NSString stringWithFormat:@"%d", self.page],
                               @"maxrow": @"20",
                               @"name": searchText};
    
    
    NSLog(@"search contact para dict %@", paraDict);
    
    [self.footer.indicator startAnimating];
    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        [self.footer.indicator stopAnimating];
        if ([GET_RETURNCODE(json) isEqualToString:@"0"]) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            
            NSArray *tmpArray = [Utility deCryptJsonDict:json OfJsonKey:@"DataList"];
            DLog(@"tmpArray %@", tmpArray);
            
            [tmpArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                SearchContact *contact = [SearchContact createEntity];
                contact.username = [dict objectForKey:@"username"];
                [self.dataSource addObject:contact];
            }];
            
            self.page++;
            
            if ([self finishLoad]) {
                self.footer.titleLabel.text = @"加载完成";
            }
            else if (self.page == 1){
                [self initTableFooter];
            }
            
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.footer.indicator stopAnimating];
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (BOOL)finishLoad
{
    if (self.dataSource.count == 0) {
        return YES;
    }
    else if (self.dataSource.count % self.maxrow.intValue != 0){
        return YES;
    }
    return NO;
}

@end
