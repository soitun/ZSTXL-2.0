//
//  StarInvAgencyViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-18.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "CustomBaseTableViewController.h"
#import "InformationCell.h"

@interface CustomBaseTableViewController ()

@end

@implementation CustomBaseTableViewController

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
    
    self.dataSourceArray = [NSMutableArray array];
    
    self.view.backgroundColor = bgGreyColor;
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-64) style:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = bgGreyColor;
    self.tableView.allowsSelection = YES;
    [self.view addSubview:self.tableView];
    
    if (![self.maxrow isValid]) {
        self.maxrow = @"20";
    }
    
    [self initEgoHeader];
//    if (self.isDataFromDB) {
//        [self requestDataFromDB];
//        
//        if (self.dataSourceArray.count == 0) {
//            [self requestData];
//        }
//        else{
//            [self.tableView reloadData];
//        }
//    }
//    else{
//        [self requestData];
//    }
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - ego view

- (void)initEgoHeader
{
    self.egoView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
    self.egoView.delegate = self;
    [self.tableView addSubview:self.egoView];
    [self.egoView refreshLastUpdatedDate];
}

#pragma mark - request data

- (void)requestData
{
    NSDictionary *para = [self requestPara];
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        
        if (self.reloading) {
            [self.dataSourceArray removeAllObjects];
        }
        

        
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            
//            DLog(@"json %@", json);
            if (self.reloading) {
                [self.dataSourceArray removeAllObjects];
            }
            
            [self parseData:json];
            
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
            
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
        [self doneLoading];
        
    } failure:^(NSError *error) {
        
        [self doneLoading];
        
        if (self.isDataFromDB) {
            [self requestDataFromDB];
            [self.tableView reloadData];
        }
        
        
        [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)parseData:(NSDictionary *)json
{
    NSString *key = [self parseKey];
    NSArray *array = [json objForKey:key];
    [self.dataSourceArray addObjectsFromArray:array];
}

- (BOOL)requestFinished
{
    if (self.dataSourceArray.count == 0 || self.dataSourceArray.count % self.maxrow.intValue != 0) {
        return YES;
    }
    return NO;
}

#pragma mark - table view

- (void)initTableFooter
{
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:self options:nil] lastObject];
    self.tableView.tableFooterView = self.footer;
    self.footer.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (BOOL)tableViewShouldSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.reloading) {
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - ego delegate

- (void)doneLoading
{
    self.reloading = NO;
    [self.egoView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    self.page = 0;
    self.reloading = YES;
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

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.egoView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.egoView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - table footer delegate

- (void)LoadMoreFooterTap:(LoadMoreFooter *)footer
{
    if ([self requestFinished]) {
        return;
    }
    else{
        [self requestData];
    }
}

@end
