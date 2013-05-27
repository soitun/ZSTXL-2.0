//
//  ZhaoshangInfoViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ZhaoshangInfoViewController.h"
#import "ZSInfoPersonInfoCell.h"
#import "ZSInfoCell.h"
#import "ZSInfoContactCell.h"

@interface ZhaoshangInfoViewController ()

@end

@implementation ZhaoshangInfoViewController

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
    [kAppDelegate.tabController hidesTabBar:YES animated:YES];
    self.tableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [kAppDelegate.tabController hidesTabBar:NO animated:YES];
    self.tableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-49);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"招商详情";
    self.titleArray = [NSMutableArray arrayWithArray:@[@"商品名称或简介名称", @"通用名", @"国药准字号", @"剂型", @"生产企业", @"招商区域", @"产品优势", @"销售方向", @"招商性质", @"适应症"]];
    
    self.contentArray = [NSMutableArray arrayWithArray:@[@"国金企业", @"小儿咳喘灵颗粒", @"Z20063280", @"颗粒型", @"河北国金药业有限责任公司", @"北京", @"医保甲类", @"医院、药店", @"暂无内容", @"宣肺、清热、止咳、祛痰。用于上呼吸道感染引起的咳嗽。"]];
    
    self.tableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-49);
    self.tableView.bounces = NO;
    [self initNavBar];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    if (indexPath.row == 0) {
        height = 106.f;
    }else if(indexPath.row == self.titleArray.count + 1){
        height = 240;
    }else{
        height = 61.f;
    }
return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZSInfoPersonInfoCell" owner:nil options:nil] lastObject];
        [((ZSInfoPersonInfoCell *)cell).headIcon setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"avatar"]];
        ((ZSInfoPersonInfoCell *)cell).nameLabel.text = @"刘月荣";
        ((ZSInfoPersonInfoCell *)cell).useridLabel.text = @"123456";
    } else if (indexPath.row == self.titleArray.count+1){

        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZSInfoContactCell" owner:nil options:nil] lastObject];
        ((ZSInfoContactCell *)cell).nameLabel.text = @"蔡经理";
        ((ZSInfoContactCell *)cell).tenantLabel.text = @"盛杰奥品牌营销中心";
        ((ZSInfoContactCell *)cell).addrLabel.text = @"长春市陕西路14栋";
        ((ZSInfoContactCell *)cell).telLabel.text = @"15590249977";
        ((ZSInfoContactCell *)cell).mailLabel.text = @"32421999@qq.com";
        ((ZSInfoContactCell *)cell).faxLabel.text = @"0431-88989333";
        ((ZSInfoContactCell *)cell).QQLabel.text = @"32421999";
        
        
    } else {
        
        static NSString *cellId = @"ZSInfoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZSInfoCell" owner:nil options:nil] lastObject];
        }
        
        ((ZSInfoCell *)cell).nameLabel.text = [self.titleArray objectAtIndex:indexPath.row-1];
        ((ZSInfoCell *)cell).contentLabel.text = [self.contentArray objectAtIndex:indexPath.row-1];
        
        if (indexPath.row == self.titleArray.count) {
            ((ZSInfoCell *)cell).separator.hidden = YES;
        }

    }
    return cell;
}



@end
