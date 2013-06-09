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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"招商详情";
    self.titleArray = [NSMutableArray arrayWithArray:@[@"商品名称或简介名称", @"通用名", @"国药准字号", @"剂型", @"生产企业", @"招商区域", @"产品优势", @"销售方向", @"招商性质", @"适应症"]];
    
    self.contentArray = [NSMutableArray arrayWithArray:@[@"国金企业", @"小儿咳喘灵颗粒", @"Z20063280", @"颗粒型", @"河北国金药业有限责任公司", @"北京", @"医保甲类", @"医院、药店", @"暂无内容", @"宣肺、清热、止咳、祛痰。用于上呼吸道感染引起的咳嗽。"]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106, 320, SCREEN_HEIGHT-64-106) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    [self initHeaderView];
    [self initNavBar];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.contactView) {
        [self.contactView removeFromSuperview];
        self.contactView = nil;
    }
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

- (void)initHeaderView
{
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"ZSInfoHeader" owner:nil options:nil] lastObject];
    self.header.delegate = self;
    self.header.frame = CGRectMake(0, 0, 320, 106);
    [self.view addSubview:self.header];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 61.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ZSInfoCell";
    ZSInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZSInfoCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.contentLabel.text = [self.contentArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == self.titleArray.count-1) {
        cell.separator.hidden = YES;
    }
    else{
        cell.separator.hidden = NO;
    }

    return cell;
}

#pragma mark - header delegate

- (void)zsINfoHeaderContactStar
{
    
}

- (void)zsInfoHeaderContactMe
{
    if (!self.contactView) {
        self.contactView = [[[NSBundle mainBundle] loadNibNamed:@"ZSInfoContactView" owner:nil options:nil] lastObject];
        self.contactView.delegate = self;
        self.contactView.frame = CGRectMake(121, 42, 187, 53);
        [self.header addSubview:self.contactView];
    }

}

#pragma mark - zsinfo contact view delegate

- (void)zsInfoContactViewChat
{
    [self.contactView removeFromSuperview];
    self.contactView = nil;
}

- (void)zsInfoContactViewTel
{
    [self.contactView removeFromSuperview];
    self.contactView = nil;
}




@end
