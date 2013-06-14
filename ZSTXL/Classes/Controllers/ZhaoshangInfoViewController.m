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
    self.view.backgroundColor = bgGreyColor;
    self.title = @"招商详情";
    self.dataSourceArray = [NSMutableArray array];
    self.titleArray = @[@"商品名称或简介名称", @"通用名", @"国药准字号", @"剂型", @"生产企业", @"招商区域", @"产品优势", @"销售方向", @"招商性质", @"适应症"];
    self.keyArray = @[@"productname", @"commdrugname", @"approvalnumber", @"dosage", @"companyname", @"placename", @"superiority", @"direction", @"quale", @"indication"];
    for (int i=0; i<self.keyArray.count; i++) {
        [self.dataSourceArray addObject:@""];
    }
    
//    self.contentArray = [NSMutableArray arrayWithArray:@[@"国金企业", @"小儿咳喘灵颗粒", @"Z20063280", @"颗粒型", @"河北国金药业有限责任公司", @"北京", @"医保甲类", @"医院、药店", @"暂无内容", @"宣肺、清热、止咳、祛痰。用于上呼吸道感染引起的咳嗽。"]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106, 320, SCREEN_HEIGHT-64-106) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self initHeaderView];
    [self initNavBar];
    [self requestData];
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

#pragma mark - request data

- (void)requestData
{
    NSDictionary *para = @{@"path": @"getZsInvestmentDetail.json",
                           @"investid": self.investmentId,
                           @"userid": kAppDelegate.userId};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        DLog(@"json %@", json);
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            [self updateData:json];
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
//    NSDictionary *starPara = nil;
//    [DreamFactoryClient getWithURLParameters:starPara success:^(NSDictionary *json) {
//        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
//            NSString *status = [[json objForKey:@"state"] stringValue];
//            if ([status isEqualToString:@"0"]) {
//                [self.header.starButton setImage:[UIImage imageNamed:@"img_zs_star"] forState:UIControlStateNormal];
//                self.isStar = NO;
//            } else {
//                [self.header.starButton setImage:[UIImage imageNamed:@"img_zs_star_p"] forState:UIControlStateNormal];
//                self.isStar = YES;
//            }
//            
//            [self updateDB];
//            
//        } else {
//            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
//        }
//    } failure:^(NSError *error) {
//        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
//    }];
}

- (void)updateData:(NSDictionary *)json
{
    NSDictionary *dict = [json objForKey:@"InvestmentDetail"];
    
    [self.keyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.dataSourceArray replaceObjectAtIndex:idx withObject:[dict objForKey:obj]];
    }];
    
    //header
    NSString *credit = [dict objForKey:@"credit"];
    if ([credit isEqualToString:@"无信用评级"]) {
        self.header.xunBImage.hidden = YES;
    }
    else{
        self.header.xunBImage.hidden = NO;
        self.header.xunBImage.image = [UIImage imageByName:credit];
    }
    
    NSString *isMember = [[dict objForKey:@"ismember"] stringValue];
    if ([isMember isEqualToString:@"1"]) {
        self.header.xunImage.hidden = NO;
    }
    else{
        self.header.xunImage.hidden = YES;
    }
    
    NSString *isVip = [[dict objForKey:@"isvip"] stringValue];
    if ([isVip isEqualToString:@"1"]) {
        self.header.xunVImage.hidden = NO;
    }
    else{
        self.header.xunVImage.hidden = YES;
    }
    
    NSString *username = [dict objForKey:@"username"];
    self.header.nameLabel.text = username;
    
    NSString *userid = [dict objForKey:@"userid"];
    self.header.useridLabel.text = userid;
    
    NSString *userimg = [dict objForKey:@"userimg"];
    [self.header.avatar setImageWithURL:[NSURL URLWithString:userimg] placeholderImage:[UIImage imageNamed:@"home_icon"]];
    
    //收藏
    NSString *isfocus = [[dict objForKey:@"isfocusvar"] stringValue];
    if ([isfocus isEqualToString:@"1"]) {
        [self.header.starButton setImage:[UIImage imageNamed:@"icon_zs_star_p"] forState:UIControlStateNormal];
    }
    else{
        [self.header.starButton setImage:[UIImage imageNamed:@"icon_zs_star"] forState:UIControlStateNormal];
    }
}

- (void)updateDB
{
    
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
    ZSInfoCell *cell = (ZSInfoCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == self.dataSourceArray.count-1) {
        [cell layoutSubviews];
        CGFloat height = CGRectGetHeight(cell.contentLabel.frame);
        return height + 40.f;
    }
    else{
        return 61.f;
    }
    return 0.f;
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
    cell.contentLabel.text = [self.dataSourceArray objectAtIndex:indexPath.row];
    
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
    NSString *myUid = kAppDelegate.userId;
    NSDictionary *dict = nil;
    if (self.isStar) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:@"delCollect.json", @"path", myUid, @"userid", self.investmentId, @"commid", nil];
    } else {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:@"addCollect.json", @"path", myUid, @"userid", self.investmentId, @"commid", nil];
    }
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            if (self.isStar) {
                [kAppDelegate showWithCustomAlertViewWithText:@"已经取消收藏" andImageName:nil];
                [self.header.starButton setImage:[UIImage imageNamed:@"icon_zs_star"] forState:UIControlStateNormal];
                self.isStar = NO;
            } else {
                [kAppDelegate showWithCustomAlertViewWithText:@"添加收藏成功" andImageName:nil];
                [self.header.starButton setImage:[UIImage imageNamed:@"icon_zs_star_p"] forState:UIControlStateNormal];
                self.isStar = YES;
            }
            
            [self updateDB];
            
        } else {
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
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
