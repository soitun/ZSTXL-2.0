//
//  FriendInvAgencyViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-19.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "OtherInvAgencyViewController.h"
#import "ZhaoshangPharListCell.h"
#import "ZhaoshangInfoViewController.h"

@interface OtherInvAgencyViewController ()

@end

@implementation OtherInvAgencyViewController

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
    
    [self initNavBar];
    
    NSString *title = [NSString stringWithFormat:@"%@的招商代理信息", self.username];
    self.title = title;
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
    NSString *page = [NSString stringWithFormat:@"%d", self.page];
    
    NSDictionary *para = @{@"path": @"getZsFrienInvestAgencyList.json",
                           @"userid": kAppDelegate.userId,
                           @"otheruserid": self.userId,
                           @"proviceid": [PersistenceHelper dataForKey:kProvinceId],
                           @"cityid": [PersistenceHelper dataForKey:kCityId],
                           @"page": page,
                           @"maxrow": self.maxrow};
    
    return para;
}

- (NSString *)parseKey
{
    return @"DataList";
}

#pragma mark - table view 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ZhaoshangPharListCell";
    ZhaoshangPharListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZhaoshangPharListCell" owner:self options:nil] lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ZhaoshangPharListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *type = [[dict objForKey:@"type"] stringValue];
    
    if ([type isEqualToString:@"1"]) {
        cell.zsdlBaseImage.image = [UIImage imageNamed:@"img_zhaoshang"];
        cell.zsdlLabel.text = @"招商";
        
    }
    else{
        cell.zsdlBaseImage.image = [UIImage imageNamed:@"img_daili"];
        cell.zsdlLabel.text = @"代理";
    }
    
    cell.pharNameLabel.text = [dict objForKey:@"productname"];
    cell.companyNameLabel.text = [dict objForKey:@"companyname"];
    cell.areaLabel.text = [dict objForKey:@"placename"];
    cell.usernameLabel.text = [dict objForKey:@"username"];
    
    [cell.pharImage setImageWithURL:[NSURL URLWithString:[dict objForKey:@"investmentimgurl"]] placeholderImage:[UIImage imageNamed:@"img_zs"]];
    
    NSString *isMember = [[dict objForKey:@"ismember"] stringValue];
    if ([isMember isEqualToString:@"1"]) {
        cell.xunImage.hidden = NO;
    }
    else{
        cell.xunImage.hidden = YES;
    }
    
    NSString *isVip = [[dict objForKey:@"isVip"] stringValue];
    if ([isVip isEqualToString:@"1"]) {
        cell.xunVImage.hidden = NO;
    }
    else{
        cell.xunImage.hidden = YES;
    }
    
    NSString *creditlevel = [dict objForKey:@"creditlevel"];
    
    if ([creditlevel isEqualToString:@"无信用评级"]) {
        cell.xunBImage.hidden = YES;
    }
    else{
        cell.xunBImage.hidden = NO;
        cell.xunBImage.image = [UIImage imageNamed:@"creditlevel"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DLog(@"grage %@", [dict objForKey:@"creditlevel"]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    ZhaoshangInfoViewController *zhaoshangInfoVC = [[[ZhaoshangInfoViewController alloc] init] autorelease];
    zhaoshangInfoVC.investmentId = [dict objForKey:@"investmentid"];
    [self.navigationController pushViewController:zhaoshangInfoVC animated:YES];
}


@end
