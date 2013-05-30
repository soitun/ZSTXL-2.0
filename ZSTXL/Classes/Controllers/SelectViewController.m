//
//  SelectViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SelectViewController.h"
#import "SettingCell.h"
#import "CustomCellBackgroundView.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [kAppDelegate.tabController hidesTabBar:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [kAppDelegate.tabController hidesTabBar:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"筛选";
    self.leftArray = @[@"招商/代理", @"类别偏好"];
    self.tableView.backgroundView = nil;
    [self initNavBar];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - table view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.leftArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:nil options:nil] lastObject];
    cell.frame = CGRectMake(0, 0, 320, 44);
    cell.selectImage.hidden = YES;
    cell.switchImage.hidden = YES;
    cell.onLabel.hidden = YES;
    cell.offLabel.hidden = YES;

    
    
    CustomCellBackgroundViewPosition pos;
    
    if (indexPath.row == 0) {
        pos = CustomCellBackgroundViewPositionTop;
    }
    else{
        pos = CustomCellBackgroundViewPositionBottom;
    }
    
    CustomCellBackgroundView *cellBg = [[CustomCellBackgroundView alloc] initWithFrame:cell.frame];
    cellBg.position = pos;
    cellBg.fillColor = [UIColor whiteColor];
    cellBg.borderColor = kCellBorderColor;
    cellBg.cornerRadius = 5.f;
    cell.backgroundView = cellBg;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setTextColor:kContentBlueColor];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    cell.textLabel.text = [self.leftArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self selectZhaoShangDaiLi];
    }
    else{
        [self selectPharCategory];
    }
}

#pragma mark - table selector

- (void)selectZhaoShangDaiLi
{
    DLog(@"选择招商代理");
}

- (void)selectPharCategory
{
    DLog(@"选择药品类别");
}

- (IBAction)confirm:(UIButton *)sender {
}
@end
