//
//  FinanceInfoViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-7.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "FinanceInfoViewController.h"
#import "CustomCellBackgroundView.h"
#import "FinanceCell.h"

@interface FinanceInfoViewController ()

@end

@implementation FinanceInfoViewController

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
    self.title = @"财务信息";
    self.leftArray = @[@"短信：", @"代金券：", @"现金：", @"我邀请的人数："];
    
    self.tableView.separatorColor = kCellBorderColor;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = bgGreyColor;
    
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_accountLabel release];
    [_gradeLabel release];
    [_creditLabel release];
    [_telLabel release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAccountLabel:nil];
    [self setGradeLabel:nil];
    [self setCreditLabel:nil];
    [self setTelLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
- (IBAction)rechargeAction:(UIButton *)sender
{
    DLog(@"充值");
}

- (IBAction)queryAction:(UIButton *)sender
{
    DLog(@"查询");
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"FinanceCell";
    FinanceCell *cell = (FinanceCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FinanceCell" owner:nil options:nil] lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath OfTableView:tableView];
    return cell;
}

- (UITableViewCell *)configureCell:(FinanceCell *)cell atIndexPath:(NSIndexPath *)indexPath OfTableView:(UITableView *)tableView
{
    cell.nameLabel.text = [self.leftArray objectAtIndex:indexPath.row];
    cell.contentLabel.text = @"10000";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CustomCellBackgroundViewPosition pos;
    if (indexPath.row == 0) {
        pos = CustomCellBackgroundViewPositionTop;
    }else if (indexPath.row == self.leftArray.count-1){
        pos = CustomCellBackgroundViewPositionBottom;
    }else{
        pos = CustomCellBackgroundViewPositionMiddle;
    }
    
    [Utility groupTableView:tableView addBgViewForCell:cell withCellPos:pos];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

@end
