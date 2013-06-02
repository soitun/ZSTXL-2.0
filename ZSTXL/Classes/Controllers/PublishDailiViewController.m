//
//  PublishDailiViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishDailiViewController.h"
#import "SettingCell.h"
#import "ConfirmFooterView.h"

@interface PublishDailiViewController ()

@end

@implementation PublishDailiViewController

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
    self.title = @"发布代理";
    self.titleArray = @[@"代理方向：", @"代理区域：", @"代理渠道：", @"代理优势：", @"信息有效期："];
    self.selectorArray = @[@"dailiTo", @"dailiArea", @"dailiChnnel", @"dailiAdvantage", @"infoPeriod"];
    
    [self initNavBar];
    [self initTableFooter];
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
    ConfirmFooterView *footer = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmFooter" owner:nil options:nil] lastObject];
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SettingCell";
    SettingCell *commonCell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (commonCell == nil) {
        commonCell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:nil options:nil] lastObject];
    }
    
    [Utility groupTableView:tableView addBgViewForCell:commonCell withCellPos:CustomCellBackgroundViewPositionSingle];
    commonCell.textLabel.text = [self.titleArray objectAtIndex:indexPath.section-1];
    commonCell.selectImage.hidden = YES;
    return commonCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEL sel = NSSelectorFromString([self.selectorArray objectAtIndex:indexPath.section]);
    [self performSelector:sel];
}

- (void)dailiTo
{
    
}

- (void)dailiArea
{
    
}

- (void)dailiChannel
{
    
}

- (void)dailiAdvantage
{
    
}

- (void)infoPeriod
{
    
}

#pragma mark - confirm footer

- (void)confirmFooterViewLeftAction
{
    
}

- (void)confirmFooterViewRightAction
{
    
}

@end
