//
//  AllContactViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-22.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "AllContactViewController.h"
#import "OtherHomepageViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "SearchContactCell.h"
#import "LoadMoreCell.h"
#import "LoadMoreFooter.h"

@interface AllContactViewController ()

@end

@implementation AllContactViewController

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
    self.sortid = 0;
    self.dataSourceArray = [NSMutableArray array];
    [self initTableFooter];
    [self getAllContactFromDB];
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

- (void)getAllContactFromDB
{
    self.page = 0;
    [self.dataSourceArray removeAllObjects];
    //    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@ AND loginid == %@", [PersistenceHelper dataForKey:kCityId], kAppDelegate.userId];
    NSArray *contactArray = [AllContact findAllSortedBy:@"sortid" ascending:YES withPredicate:pred];
    if (contactArray.count > 0) {
        self.page = ceil(((CGFloat)contactArray.count / 50));
        [self.dataSourceArray addObjectsFromArray:contactArray];
        [self.tableView reloadData];
        self.sortid = contactArray.count;
    }
    else{
        [self getInvestmentUserListFromServer];
    }
}

- (void)getInvestmentUserListFromServer
{
    NSString *cityName = [PersistenceHelper dataForKey:kCityName];
    NSString *cityId = [[Utility getCityIdByCityName:cityName] cityId];
    NSString *provinceId = [[Utility getCityIdByCityName:cityName] proId];

    NSString *listPage = [NSString stringWithFormat:@"%d", self.page];
    NSString *userid = kAppDelegate.userId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:provinceId, @"provinceid",
                          cityId, @"cityid",
                          listPage, @"page",
                          @"50", @"maxrow",
                          userid, @"userid",
                          @"getAllUserListByPage.json", @"path", nil];
    
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            if (![[json objForKey:@"InvestmentUserList"] isValid]) {
                //                [self.contactArray removeAllObjects];
//                [self.tableView reloadData];
                [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:@"加载完毕" andImageName:nil];
                //                NSLog(@"%@ 该地区暂无商家", [PersistenceHelper dataForKey:kCityName]);
                return;
            }
            else{
                NSArray *jsonArray = [self deCryptJsonDict:json OfJsonKey:@"InvestmentUserList"];
                
                [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                    //                NSLog(@"contact Dict: %@", contactDict);
                    
                    AllContact *contact = [AllContact MR_createEntity];
                    
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
                    contact.sortid = [NSString stringWithFormat:@"%d", self.sortid++];
                    [self.dataSourceArray addObject:contact];
                    DB_SAVE();
                }];
                
                self.page++;
                [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
                [self.tableView reloadData];
            }
        } else {
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)loadMoreContact
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSourceArray.count inSection:0];
    LoadMoreCell *loadMoreCell = (LoadMoreCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [loadMoreCell.indicator startAnimating];
    
    [self getInvestmentUserListFromServer];
}

- (NSArray *)deCryptJsonDict:(NSDictionary *)dict OfJsonKey:(NSString *)jsonKey
{
    NSString *jsonEncryptStr = [[dict objForKey:jsonKey] removeSpace];
    NSString *userid = [kAppDelegate userId];
    NSMutableString *key = [NSMutableString stringWithString:[kBaseKey substringToIndex:24-userid.length]];
    [key appendFormat:@"%@", userid];
    NSArray *jsonArray = [[DES3Util decrypt:jsonEncryptStr withKey:key] objectFromJSONString];
    return jsonArray;
}

#pragma mark - table view

- (void)initTableFooter
{
    LoadMoreFooter *footer = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:nil options:nil] lastObject];
    footer.titleLabel.text = @"加载更多";
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"contact array count %d", self.dataSourceArray.count);
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ContactCell";
    ContactCell * cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.contact = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    [self configureCell:cell atIndexPath:indexPath OfTableView:tableView];
    
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath OfTableView:(UITableView *)tableView
{
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    AllContact *userDetail;
    
    userDetail = [self.dataSourceArray objectAtIndex:indexPath.row];
    
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
    [self showContactView];
}

- (void)LoadMoreFooterTap
{
    [self getInvestmentUserListFromServer];
}

- (void)contactCellTapAvatarOfContact:(Contact *)contact
{
    OtherHomepageViewController *otherProfileVC = [[[OtherHomepageViewController alloc] init] autorelease];
    otherProfileVC.contact = contact;
    if ([self.parentController respondsToSelector:@selector(pushViewController:)]) {
        [self.parentController performSelector:@selector(pushViewController:) withObject:otherProfileVC];
    }
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
}

- (void)removeBg
{
    [self.bgControl removeFromSuperview];
}


@end
