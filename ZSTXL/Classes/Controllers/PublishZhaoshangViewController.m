//
//  PublishZhaoshangViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishZhaoshangViewController.h"
#import "TextFieldCell.h"
#import "SettingCell.h"
#import "CustomCellBackgroundView.h"
#import "PublishSellToViewController.h"
#import "PublishZhaoshangPropertyViewController.h"
#import "PublishProductAdvantageViewController.h"
#import "PublishPeriodViewController.h"

@interface PublishZhaoshangViewController ()

@end

@implementation PublishZhaoshangViewController

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
    self.title = @"发布招商信息";
    self.titleArray = @[@"区域选择：", @"销售方向：", @"招商性质：", @"产品优势：", @"信息有效期："];
    self.selectorArray = @[@"selectArea", @"sellTo", @"canvassProperty", @"productAdvantage", @"infoPeriod"];
    self.navigationController.delegate = self;
    
    self.tableView.backgroundView = nil;
    [self initTableFooter];
    [self initNavBar];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
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
    [_drugImage release];
    [_drugNameLabel release];
    [_drugNumLabel release];
    [_producerLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setDrugImage:nil];
    [self setDrugNameLabel:nil];
    [self setDrugNumLabel:nil];
    [self setProducerLabel:nil];
    [super viewDidUnload];
}

#pragma mark - nav back button

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
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"setting_confirm_l"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"setting_confirm_l_p"] forState:UIControlStateHighlighted];
    confirmButton.frame = CGRectMake(15, 10, 289, 48);
    [confirmButton addTarget:self action:@selector(confirmPublish:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
    
    [self.tableView setTableFooterView:footerView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *textCellId = @"TextFieldCell";
    static NSString *commonCellId = @"SettingCell";
    
    if (indexPath.section == 0) {
        TextFieldCell *textFieldCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:textCellId];
        if (textFieldCell == nil) {
            textFieldCell = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:nil options:nil] lastObject];
        }
        
        [Utility groupTableView:tableView addBgViewForCell:textFieldCell withCellPos:CustomCellBackgroundViewPositionSingle];
        textFieldCell.accessoryType = UITableViewCellAccessoryNone;
        return textFieldCell;
    }
    else{
        SettingCell *commonCell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:commonCellId];
        if (commonCell == nil) {
            commonCell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:nil options:nil] lastObject];
        }
        
        [Utility groupTableView:tableView addBgViewForCell:commonCell withCellPos:CustomCellBackgroundViewPositionSingle];
        commonCell.textLabel.text = [self.titleArray objectAtIndex:indexPath.section-1];
        commonCell.selectImage.hidden = YES;
        return commonCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"did select");
    if (indexPath.section == 0) {
        
    }
    else{
        SEL sel = NSSelectorFromString([self.selectorArray objectAtIndex:indexPath.section - 1]);
        [self performSelector:sel];
    }
}

#pragma mark - table method

- (void)selectArea
{
    
}

- (void)sellTo
{
    DLog(@"sellto");
    PublishSellToViewController *publishSellToVC = [[[PublishSellToViewController alloc] init] autorelease];
    [self.navigationController pushViewController:publishSellToVC animated:YES];
}

- (void)canvassProperty
{
    PublishZhaoshangPropertyViewController *publishZhaoshangPropertyViewController = [[[PublishZhaoshangPropertyViewController alloc] init] autorelease];
    [self.navigationController pushViewController:publishZhaoshangPropertyViewController animated:YES];
}

- (void)productAdvantage
{
    PublishProductAdvantageViewController *publishProductAdvantageViewController = [[[PublishProductAdvantageViewController alloc] init] autorelease];
    [self.navigationController pushViewController:publishProductAdvantageViewController animated:YES];
}

- (void)infoPeriod
{
    PublishPeriodViewController *publishPeriodViewController = [[[PublishPeriodViewController alloc] init] autorelease];
    [self.navigationController pushViewController:publishPeriodViewController animated:YES];
}

- (void)confirmPublish:(UIButton *)sender
{
    
}

@end
