//
//  PublishBaseViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishBaseViewController.h"
#import "SettingCell.h"
#import "ConfirmFooterView.h"

@interface PublishBaseViewController ()

@end

@implementation PublishBaseViewController

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
    
    self.view.backgroundColor = RGBCOLOR(243, 244, 245);
    self.dataSourceArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    
    [self requestData];
    [self initTableView];
    [self initNavBar];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableVeiw release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableVeiw:nil];
    [super viewDidUnload];
}

#pragma mark - request data

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:[self para] success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            DLog(@"json %@", json);
            [self initTableFooter];
            [self analyseData:json];
            [self.tableVeiw reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
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

- (void)initTableView
{
    self.tableVeiw = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped] autorelease];
    self.tableVeiw.delegate = self;
    self.tableVeiw.dataSource = self;
    self.tableVeiw.backgroundView = nil;
    [self.view addSubview:self.tableVeiw];
}

- (void)initTableFooter
{
    ConfirmFooterView *footer = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmFooterView" owner:nil options:nil] lastObject];
    footer.delegate = self;
    self.tableVeiw.tableFooterView = footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SettingCell";
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:nil options:nil] lastObject];
    }
    
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    if ([self.selectArray containsObject:dict]) {
        cell.selectImage.image = [UIImage imageNamed:@"login_select"];
    }
    else{
        cell.selectImage.image = [UIImage imageNamed:@"login_noselect"];
    }
    
    CustomCellBackgroundViewPosition pos;
    if (indexPath.row == 0) {
        pos = CustomCellBackgroundViewPositionTop;
    } else if (indexPath.row == self.dataSourceArray.count-1) {
        pos = CustomCellBackgroundViewPositionBottom;
    }else{
        pos = CustomCellBackgroundViewPositionMiddle;
    }
    
    [Utility groupTableView:tableView addBgViewForCell:cell withCellPos:pos];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [self titleNameOfDict:dict];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    if (self.allowMultiSelect) {
        if ([self.selectArray containsObject:dict]) {
            [self.selectArray removeObject:dict];
        }
        else{
            [self.selectArray addObject:dict];
        }
        
        [self.tableVeiw reloadData];
    }
    else{
        if (![self.selectArray containsObject:dict]) {
            [self.selectArray removeAllObjects];
            [self.selectArray addObject:dict];
        }
        
        [self.tableVeiw reloadData];
    }
    

}

#pragma mark - confirm footer delegate

- (void)confirmFooterViewLeftAction
{
    if ([self.delegate respondsToSelector:@selector(publishSelectFinish:withType:)]) {
        [self.delegate performSelector:@selector(publishSelectFinish:withType:) withObject:self.selectArray withObject:self.type];
        [self popVC:nil];
    }
}

- (void)confirmFooterViewRightAction
{
    [self popVC:nil];
}


@end
