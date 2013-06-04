//
//  WeekDayViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-4.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "WeekDayViewController.h"
#import "SettingDupCell.h"
#import "CustomCellBackgroundView.h"

@interface WeekDayViewController ()

@end

@implementation WeekDayViewController

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
    self.title = @"重复";
    self.weekArray = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日"];
    self.selectArray = [NSMutableArray array];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = bgGreyColor;
    
    [self initNavBar];
    [self initTableFooter];
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

#pragma mark - table view

- (void)initTableFooter
{
    ConfirmFooterView *footer = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmFooterView" owner:nil options:nil] lastObject];
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weekArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SettingDupCell";
    SettingDupCell *cell = (SettingDupCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingDupCell" owner:nil options:nil] lastObject];
    }
    
    CustomCellBackgroundViewPosition pos;
    if (indexPath.row == 0) {
        pos = CustomCellBackgroundViewPositionTop;
    }else if (indexPath.row == self.weekArray.count-1){
        pos = CustomCellBackgroundViewPositionBottom;
    }else{
        pos = CustomCellBackgroundViewPositionMiddle;
    }
    
    [Utility groupTableView:tableView addBgViewForCell:cell withCellPos:pos];
    
    cell.titleLabel.text = [self.weekArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingDupCell *cell = (SettingDupCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *index = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    if ([self.selectArray containsObject:index]) {
        [self.selectArray removeObject:index];
        cell.selectImage.image = [UIImage imageByName:@"login_noselect"];
    }
    else{
        [self.selectArray addObject:index];
        cell.selectImage.image = [UIImage imageByName:@"login_select"];
    }
}

- (void)confirmFooterViewLeftAction
{
    PERFORM_SELECTOR_WITH_OBJECT(self.delegate, @selector(weekDaySelect:), self.selectArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmFooterViewRightAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
