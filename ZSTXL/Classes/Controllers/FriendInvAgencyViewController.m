//
//  FriendInvAgencyViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "FriendInvAgencyViewController.h"
#import "InformationCell.h"
#import "OtherInvAgencyViewController.h"

@interface FriendInvAgencyViewController ()

@end

@implementation FriendInvAgencyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isDataFromDB = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"好友的招商代理信息";
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - request data

- (NSDictionary *)requestPara
{
    
    NSDictionary *para = @{@"path": @"getAttentionInvestAgencyList.json",
                           @"myuserid": kAppDelegate.userId};
    
    return para;
}

- (NSString *)parseKey
{
    return @"DataList";
}

#pragma mark - table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"InformationCell";
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:self options:nil] lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(InformationCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    [cell.avatar setImageWithURL:[NSURL URLWithString:[dict objForKey:@"picturelinkurl"]] placeholderImage:[UIImage imageNamed:@"agency_default.png"]];
    cell.labTitle.text = [dict objForKey:@"username"];
    cell.labSubTitle.text = [dict objForKey:@"count"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    OtherInvAgencyViewController *otherInvAgencyVC = [[[OtherInvAgencyViewController alloc] init] autorelease];
    otherInvAgencyVC.userId = [dict objForKey:@"attentionuserid"];
    otherInvAgencyVC.username = [dict objForKey:@"username"];
    
    [self.navigationController pushViewController:otherInvAgencyVC animated:YES];
}

@end
