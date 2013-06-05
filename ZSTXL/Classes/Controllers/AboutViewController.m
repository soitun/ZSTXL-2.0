//
//  AboutViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-5.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "AboutViewController.h"

#import "CustomCellBackgroundView.h"
#import "UserAgreementViewController.h"
#import "PrivacyProtectViewController.h"
#import "CopyrightViewController.h"
#import "ReliefViewController.h"

#import "SettingCell.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.title = @"关于";
    self.view.backgroundColor = bgGreyColor;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    
    
    self.hidesBottomBarWhenPushed = YES;
    self.nameArray = @[@"用户协议",@"隐私保护",@"版权声明",@"免责声明"];
    self.selArray = @[@"userAgreement", @"privacyProtect",@"copyrightDeclare",@"reliefDeclare"];
    
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SettingCell";
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectImage.hidden = YES;
    cell.switchImage.hidden = YES;
    cell.onLabel.hidden = YES;
    cell.offLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.frame = CGRectMake(0, 0, 320, 44);
    CustomCellBackgroundViewPosition pos;
    if (indexPath.row == 0) {
        pos = CustomCellBackgroundViewPositionTop;
    }else if (indexPath.row == self.nameArray.count-1){
        pos = CustomCellBackgroundViewPositionBottom;
    }else{
        pos = CustomCellBackgroundViewPositionMiddle;
    }
    
    [Utility groupTableView:tableView addBgViewForCell:cell withCellPos:pos];
    cell.textLabel.text = [self.nameArray objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEL sel = NSSelectorFromString([self.selArray objectAtIndex:indexPath.row]);
    [self performSelector:sel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)userAgreement
{
    NSLog(@"userAgreement");
    UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc] init];
    [self.navigationController pushViewController:userAgreementVC animated:YES];
    [userAgreementVC release];
}

- (void)privacyProtect
{
    NSLog(@"privaceProtect");
    PrivacyProtectViewController *privacyProtectVC = [[PrivacyProtectViewController alloc] init];
    [self.navigationController pushViewController:privacyProtectVC animated:YES];
    [privacyProtectVC release];
}

- (void)copyrightDeclare
{
    NSLog(@"versionDeclare");
    CopyrightViewController *copyrightVC = [[CopyrightViewController alloc] init];
    [self.navigationController pushViewController:copyrightVC animated:YES];
    [copyrightVC release];
}

- (void)reliefDeclare
{
    NSLog(@"reliefDeclare");
    ReliefViewController *reliefVC = [[ReliefViewController alloc] init];
    [self.navigationController pushViewController:reliefVC animated:YES];
    [reliefVC release];
}


- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
