//
//  ShowSelectViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-6.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ShowSelectViewController.h"
#import "SearchContact.h"
#import "OtherHomepageViewController.h"

@interface ShowSelectViewController ()

@end

@implementation ShowSelectViewController

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
    self.title = @"筛选";
    self.dataSourceArray = [NSMutableArray array];
    self.eachArray = [NSMutableArray array];
    self.maxrow = @"50";
    
    [self initNavBar];
    [self requestData];
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

#pragma mark - shaixuan

- (void)requestData
{
    if (self.finish == NO) {
        NSString *cityId = [PersistenceHelper dataForKey:kCityId];
        NSString *provinceId = [PersistenceHelper dataForKey:kProvinceId];
        
        NSString *listPage = [NSString stringWithFormat:@"%d", self.page];
        
        NSDictionary *para = @{@"path": @"getZsUserBypreferPage.json",
                               @"cityid": cityId,
                               @"provinceid": provinceId,
                               @"maxrow": self.maxrow,
                               @"page": listPage,
                               @"preferid":self.preferId,
                               @"invagency": self.invagency,
                               @"userid": kAppDelegate.userId};
        
        
        [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
        [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            if (RETURNCODE_ISVALID(json)) {

                [self.footer.indicator stopAnimating];
                
                NSArray *jsonArray = [Utility deCryptJsonDict:json OfJsonKey:@"DataList"];
                
                [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                    //                NSLog(@"contact Dict: %@", contactDict);
                    
                    SearchContact *contact = [SearchContact createEntity];
                    
                    contact.userid = [[contactDict objForKey:@"id"] stringValue];
                    contact.username = [contactDict objForKey:@"username"];
                    contact.tel = [contactDict objForKey:@"tel"];
                    contact.mailbox = [contactDict objForKey:@"mailbox"];
                    contact.picturelinkurl = [contactDict objForKey:@"picturelinkurl"];
                    contact.col1 = [contactDict objForKey:@"col1"];
                    contact.col2 = [contactDict objForKey:@"col2"];
                    contact.col2 = [contactDict objForKey:@"col2"];
                    contact.cityid = [PersistenceHelper dataForKey:kCityId];
                    contact.loginid = [kAppDelegate userId];
                    contact.username_p = makePinYinOfName(contact.username);
                    contact.invagency = [[contactDict objForKey:@"invagency"] stringValue];
                    //                NSLog(@"name pinyin %@", contact.username_p);
                    
                    contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                    //                    contact.sortid = [NSString stringWithFormat:@"%d", self.sortid++];
                    [self.dataSourceArray addObject:contact];
                    DB_SAVE();
                }];
                
                self.page++;
                [self.tableView reloadData];
                
                [self initTableFooter];
                
                if ([self requestFinished:jsonArray]) {
                    [kAppDelegate showWithCustomAlertViewWithText:@"加载完成" andImageName:nil];
                    self.finish = YES;
                    self.footer.titleLabel.text = @"加载完成";
                }
                else{
                    self.footer.titleLabel.text = @"加载更多";
                }
                

            } else {
                
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
    
}

- (BOOL)requestFinished:(NSArray *)array
{
    if (array.count == 0) {
        return YES;
    }
    else if (array.count % self.maxrow.integerValue != 0){
        return YES;
    }
    return NO;
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

#pragma mark - table footer deleagte

- (void)LoadMoreFooterTap:(LoadMoreFooter *)footer
{
    if (self.finish) {
        return;
    }
    else{
        [footer.indicator startAnimating];
        [self requestData];
    }
}

#pragma mark - table view

- (void)initTableFooter
{
    if (!self.footerIsOn) {
        self.footerIsOn = YES;
        self.footer = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:nil options:nil] lastObject];
        self.footer.delegate = self;
        self.tableView.tableFooterView = self.footer;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ContactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:nil options:nil] lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath OfTableView:tableView];
    
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath OfTableView:(UITableView *)tableView
{
    SearchContact *userDetail = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.contact = userDetail;
    cell.delegate = self;
    
    switch (userDetail.invagency.intValue) {
        case 1:
            cell.ZDLabel.text = @"招商";
            break;
        case 2:
            cell.ZDLabel.text = @"代理";
            break;
        case 3:
            cell.ZDLabel.text = @"招商、代理";
            break;
        default:
            break;
    }
    
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:userDetail.picturelinkurl]
                  placeholderImage:[UIImage imageByName:@"avatar"]];
    
    
    if ([userDetail.remark isValid]) {
        NSMutableString *userName = [NSMutableString stringWithFormat:@"%@(%@)", userDetail.username, userDetail.remark];
        cell.nameLabel.text = userName;
    }
    else{
        cell.nameLabel.text = userDetail.username;
    }
    
    if ([userDetail.col2 isEqualToString:@"1"]) {
        cell.xun_VImage.hidden = NO;
    }
    else{
        cell.xun_VImage.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.callContact = [self.dataSourceArray objectAtIndex:indexPath.row];
    [self showContactView];
}

- (void)contactCellTapAvatarOfContact:(Contact *)contact
{
    OtherHomepageViewController *otherVC = [[[OtherHomepageViewController alloc] init] autorelease];
    otherVC.contact = contact;
    [self.navigationController pushViewController:otherVC animated:YES];
}

#pragma mark - contact view

- (void)showContactView
{
    PopContactView *contactView = [[[NSBundle mainBundle] loadNibNamed:@"PopContactView" owner:nil options:nil] lastObject];
    contactView.frame = CGRectMake(34, 150, 252, 170);
    contactView.delegate = self;
    
    self.bgControl = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)] autorelease];
    self.bgControl.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    [self.bgControl addTarget:self action:@selector(removeBg) forControlEvents:UIControlEventTouchDown];
    [self.bgControl addSubview:contactView];
    
    [kAppDelegate.window addSubview:self.bgControl];
    
}

- (void)popContactViewChat
{
    [self.bgControl removeFromSuperview];
}

- (void)popContactViewTel
{
    [self.bgControl removeFromSuperview];
    NSString *tel = [Utility deCryptTel:self.callContact.tel withUserId:self.callContact.userid];
    [Utility callContact:tel];
}

- (void)removeBg
{
    [self.bgControl removeFromSuperview];
}


@end
