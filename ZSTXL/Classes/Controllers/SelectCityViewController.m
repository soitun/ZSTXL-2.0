//
//  SelectCityViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-5.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SelectCityViewController.h"
#import "ProvinceInfo.h"
#import "CityInfo.h"
#import "ProvinceCell.h"
#import "CityCell.h"

@interface SelectCityViewController ()

@end

@implementation SelectCityViewController

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
    self.title = @"选择地区";
    self.isOpen = NO;
    
    self.dataSourceArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    [self initNavBar];
    [self getAreaData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [kAppDelegate.tabController hidesTabBar:YES animated:YES];
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
    
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:[UIImage imageNamed:@"nav_login_button"] forState:UIControlStateNormal];
    [rButton setBackgroundImage:[UIImage imageNamed:@"nav_login_button_p"] forState:UIControlStateHighlighted];
    [rButton setTitle:@"确认" forState:UIControlStateNormal];
    [rButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [rButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(selectFinished) forControlEvents:UIControlEventTouchUpInside];
    rButton.frame = CGRectMake(0, 0, 54, 32);
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:rButton] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
}

- (void)popVC:(UIButton *)sender
{
    [kAppDelegate.tabController hidesTabBar:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectFinished
{
    PERFORM_SELECTOR_WITH_OBJECT(self.delegate, @selector(SelectCityFinished:), self.selectArray);
    [self popVC:nil];
}

#pragma mark - province city info

- (void)getAreaData
{
    NSString *areaJsonPath = [[NSBundle mainBundle] pathForResource:@"getProAndCityData" ofType:@"json"];
    NSData *areaJsonData = [[[NSData alloc] initWithContentsOfFile:areaJsonPath] autorelease];
    NSMutableDictionary *areaDictTmp = [NSJSONSerialization JSONObjectWithData:areaJsonData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *provinceArrayTmp = [areaDictTmp objectForKey:@"AreaList"];
    [provinceArrayTmp enumerateObjectsUsingBlock:^(NSDictionary *proDict, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[proDict objectForKey:@"provincename"] forKey:@"provincename"];
        
        
        NSArray *cityArrayJsonTmp = [proDict objectForKey:@"citylist"];
        NSMutableArray *cityArrayTmp = [[[NSMutableArray alloc] init] autorelease];
        [cityArrayJsonTmp enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
            
            [cityArrayTmp addObject:cityDict];
        }];
        [dictionary setObject:cityArrayTmp forKey:@"citylist"];

        [self.dataSourceArray addObject:dictionary];
    }];
    
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return [[[self.dataSourceArray objectAtIndex:section] objectForKey:@"citylist"] count]+1;;
        }
    }
    return 1;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0)
    {
        return 44.f;
    }
    else{
        return 51.f;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *cityCellId = @"CityCell";
        CityCell *cell = (CityCell*)[tableView dequeueReusableCellWithIdentifier:cityCellId];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cityCellId owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        NSArray *list = [[self.dataSourceArray objectAtIndex:self.selectIndex.section] objectForKey:@"citylist"];
        NSDictionary *city = [list objectAtIndex:indexPath.row-1];
        cell.cityNameLabel.text = [city objForKey:@"cityname"];
        
        if ([self.selectArray containsObject:city]) {
            cell.selectImage.image = [UIImage imageNamed:@"login_select"];
        }
        else{
            cell.selectImage.image = [UIImage imageNamed:@"login_noselect"];
        }
        
        
        return cell;
    }else
    {
        static NSString *provinceCellId = @"ProvinceCell";
        ProvinceCell *cell = (ProvinceCell*)[tableView dequeueReusableCellWithIdentifier:provinceCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:provinceCellId owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        NSString *name = [[self.dataSourceArray objectAtIndex:indexPath.section] objectForKey:@"provincename"];
        cell.provinceLabel.text = name;
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else{
        
        if (self.allowMultiselect == YES) {
            NSDictionary *dic = [self.dataSourceArray objectAtIndex:indexPath.section];
            NSArray *list = [dic objectForKey:@"citylist"];
            NSDictionary *city = [list objectAtIndex:indexPath.row-1];
            if ([self.selectArray containsObject:city]) {
                [self.selectArray removeObject:city];
            }
            else{
                if (self.selectArray.count == 2) {
                    [kAppDelegate showWithCustomAlertViewWithText:@"最多选择两个城市" andImageName:kErrorIcon];
                    return;
                }
                
                [self.selectArray addObject:city];
            }
            
            [self.tableView reloadData];
        }
        else{
            NSDictionary *dic = [self.dataSourceArray objectAtIndex:indexPath.section];
            NSArray *list = [dic objectForKey:@"citylist"];
            NSDictionary *city = [list objectAtIndex:indexPath.row-1];
            if (![self.selectArray containsObject:city]) {
                [self.selectArray removeAllObjects];
                [self.selectArray addObject:city];
            }
            [self.tableView reloadData];
        }
        

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    [self.tableView beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = [[[self.dataSourceArray objectAtIndex:section] objectForKey:@"citylist"] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	[rowToInsert release];
	
	[self.tableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}


@end
