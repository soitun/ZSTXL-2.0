//
//  AllContactViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-22.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "AllContactViewController.h"
#import "OtherProfileViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "AllContact.h"
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:kCityChangedNoification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sortid = 0;
    self.dataSourceArray = [NSMutableArray array];
    self.maxrow = @"50";
//    [self initTableFooter];
    [self getAllContactFromDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCityChangedNoification object:nil];
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
        [self initTableFooter];
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
                          self.maxrow, @"maxrow",
                          userid, @"userid",
                          @"getAllUserListByPage.json", @"path", nil];
    
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [self.footer.indicator stopAnimating];
            
            NSArray *jsonArray = [self deCryptJsonDict:json OfJsonKey:@"InvestmentUserList"];
            
            [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                //                NSLog(@"contact Dict: %@", contactDict);
                
                AllContact *contact = [AllContact MR_createEntity];
                [contact initWithDict:contactDict];
                contact.sortid = [NSString stringWithFormat:@"%d", self.sortid++];
                [self.dataSourceArray addObject:contact];
                DB_SAVE();
            }];
            
            self.page++;
            if (self.page == 1) {
                [self initTableFooter];
            }
            
            if ([self requestFinish]) {
                self.footer.titleLabel.text = @"加载完成";
            }
            else{
                self.footer.titleLabel.text = @"加载更多";
            }
            
            [self.tableView reloadData];
            
        } else {
            
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

- (BOOL)requestFinish
{
    if (self.dataSourceArray.count == 0) {
        return YES;
    }else if(self.dataSourceArray.count % self.maxrow.intValue != 0){
        return YES;
    }
    
    return NO;
}

#pragma mark - table view

- (void)initTableFooter
{
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:nil options:nil] lastObject];
    self.footer.titleLabel.text = @"加载更多";
    self.footer.delegate = self;
    self.tableView.tableFooterView = self.footer;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell refresh];
    
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath OfTableView:(UITableView *)tableView
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact *contact = [self.dataSourceArray objectAtIndex:indexPath.row];
    PopContactView *pop = [[PopContactView alloc] initWithNib:@"PopContactView"];
    pop.contact = contact;
    pop.delegate = self;
    [pop showInView:kAppDelegate.window];
}

- (void)LoadMoreFooterTap:(LoadMoreFooter *)footer
{
    if ([self requestFinish]) {
        self.footer.titleLabel.text = @"加载完成";
        return;
    }
    [footer.indicator startAnimating];
    [self getInvestmentUserListFromServer];
}

- (void)contactCellTapAvatarOfContact:(Contact *)contact
{
    OtherProfileViewController *otherProfileVC = [[[OtherProfileViewController alloc] init] autorelease];
    otherProfileVC.contact = contact;
    if ([self.parentController respondsToSelector:@selector(pushViewController:)]) {
        [self.parentController performSelector:@selector(pushViewController:) withObject:otherProfileVC];
    }
}

#pragma mark - contact view

- (void)popContactViewChat:(Contact *)contact
{
    
}

- (void)popContactViewTel:(NSString *)tel
{
//    NSString *tel = [Utility deCryptTel:contact.tel withUserId:contact.userid];
    [Utility callContact:tel];
}

- (void)popContactViewTapAvatar:(Contact *)contact
{
    OtherProfileViewController *otherProfileVC = [[[OtherProfileViewController alloc] init] autorelease];
    otherProfileVC.contact = contact;
    if ([self.parentController respondsToSelector:@selector(pushViewController:)]) {
        [self.parentController performSelector:@selector(pushViewController:) withObject:otherProfileVC];
    }
}

#pragma mark - refresh data

- (void)refreshAction
{
    if (self.dataSourceArray.count == 0) {
        [self getAllContactFromDB];
    }
}

#pragma mark - notify

- (void)cityChanged:(NSNotification *)noti
{
    [self.dataSourceArray removeAllObjects];
    self.page = 0;
    self.sortid = 0;
    [self getAllContactFromDB];
}


@end
