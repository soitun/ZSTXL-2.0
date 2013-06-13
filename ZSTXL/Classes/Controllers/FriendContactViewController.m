//
//  FriendContactViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "FriendContactViewController.h"
#import "ContactCell.h"
#import "FriendContact.h"
#import "OtherProfileViewController.h"

@interface FriendContactViewController ()

@end

@implementation FriendContactViewController

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
    self.dataSourceArray = [NSMutableArray array];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self initContactDict];
    [self getFriendData];
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

- (void)initContactDict
{
    self.contactDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSArray *indexTitleArray = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    [indexTitleArray enumerateObjectsUsingBlock:^(NSString *indexTitle, NSUInteger idx, BOOL *stop) {
        [self.contactDict setObject:[NSMutableArray array] forKey:indexTitle];
    }];
    
    self.sectionArray = [NSMutableArray array];
}

- (void)getFriendData
{
    if (![kAppDelegate.userId isEqualToString:@"0"]) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@ AND loginid == %@ AND type == %@", [PersistenceHelper dataForKey:kCityId], [kAppDelegate userId], @"1"];
        NSArray *array = [FriendContact findAllSortedBy:@"sectionkey,username_p" ascending:YES withPredicate:pred];
        if (array.count != 0) {
            [array enumerateObjectsUsingBlock:^(FriendContact *contact, NSUInteger idx, BOOL *stop) {
                NSString *contactIndex = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                [[self.contactDict objForKey:contactIndex] addObject:contact];
            }];
            
            NSMutableSet *sectionSet = [[[NSMutableSet alloc] init] autorelease];
            [self.contactDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSMutableArray *contactArray, BOOL *stop) {
                if (contactArray.count != 0) {
                    [sectionSet addObject:key];
                }
            }];
            
            [sectionSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                [self.sectionArray addObject:obj];
            }];
            
            [self.sectionArray sortUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
                return [obj1 compare:obj2];
            }];
            
            DLog(@"section array %@", self.sectionArray);
            [self.tableView reloadData];
        }
        else{
            [self getInvestmentUserListFromServer];
        }
    }
}

- (void)getInvestmentUserListFromServer
{
    NSString *cityName = [PersistenceHelper dataForKey:kCityName];
    NSString *cityId = [PersistenceHelper dataForKey:kCityId];
    NSString *provinceId = [[Utility getCityIdByCityName:cityName] proId];
    //parameter: provinceid, cityid, userid(用来取备注),
    NSString *userid = kAppDelegate.userId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:provinceId, @"provinceid",
                          cityId, @"cityid",
                          userid, @"userid",
                          @"getZsAttentionUserByArea.json", @"path", nil];
    
    NSLog(@"all contact dict %@", dict);
    
    
    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            //            NSLog(@"friend json %@", json);
            //            NSLog(@"pred %@", self.fetchedResultsController.fetchRequest.predicate);
            NSArray *friendArray = [Utility deCryptJsonDict:json OfJsonKey:@"DataList"];
            //            NSLog(@"friend arrat %@", friendArray);
            
            [friendArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                //                NSLog(@"contact Dict: %@", contactDict);
                
                FriendContact *contact = [FriendContact MR_createEntity];
                [contact initWithDict:contactDict];
                contact.areaname = [contactDict objForKey:@"areaname"];
                contact.type = @"1";
                [[self.contactDict objForKey:contact.sectionkey] addObject:contact];
                DB_SAVE();
            }];
            
            [self.sectionArray removeAllObjects];
            
            [self.contactDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSArray * obj, BOOL *stop) {
                if (obj.count != 0) {
                    [self.sectionArray addObject:key];
                }
            }];
            
            
            [self.sectionArray sortUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
                return [obj1 compare:obj2];
            }];
            
//            DLog(@"%@", self.contactDict);
            
            [self.tableView reloadData];
            
            
        } else {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.contactDict objForKey:[self.sectionArray objectAtIndex:section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ContactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSString *sectionKey = [self.sectionArray objectAtIndex:indexPath.section];
    FriendContact *contact = [[self.contactDict objectForKey:sectionKey] objectAtIndex:indexPath.row];
    cell.contact = contact;
    cell.delegate = self;
    
    [cell refresh];
    cell.cityLabel.text = ((FriendContact *)contact).areaname;
    
    return cell;
}

//弃用
- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;
    
    NSString *sectionKey = [self.sectionArray objectAtIndex:indexPath.section];
    Contact *contact = [[self.contactDict objectForKey:sectionKey] objectAtIndex:indexPath.row];
    cell.contact = contact;
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    FriendContact *userDetail = [[self.contactDict objForKey:[self.sectionArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    switch (userDetail.invagency.intValue) {
        case 1:
            cell.ZDLabel.text = @"招商";
            break;
        case 2:
            cell.ZDLabel.text = @"代理";
            break;
        case 3:
            cell.ZDLabel.text = @"招商/代理";
            break;
        default:
            break;
    }
    
    
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:userDetail.picturelinkurl] placeholderImage:[UIImage imageByName:@"avatar"]];
    
    if ([userDetail.remark isValid]) {
        NSMutableString *userName = [NSMutableString stringWithFormat:@"%@(%@)", userDetail.username, userDetail.remark];
        cell.nameLabel.text = userName;
    }
    else{
        cell.nameLabel.text = userDetail.username;
    }
    
//    if ([userDetail.col2 isEqualToString:@"1"]) {
//        cell.xun_VImage.hidden = NO;
//    }
//    else{
//        cell.xun_VImage.hidden = YES;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey = [self.sectionArray objectAtIndex:indexPath.section];
    Contact *contact = [[self.contactDict objectForKey:sectionKey] objectAtIndex:indexPath.row];

    PopContactView *contactView = [[PopContactView alloc] initWithNib:@"PopContactView"];
    contactView.delegate = self;
    contactView.contact = contact;
    [contactView showInView:kAppDelegate.window];
}

- (void)contactCellTapAvatarOfContact:(Contact *)contact
{
    OtherProfileViewController *otherProfileVC = [[OtherProfileViewController alloc] init];
    otherProfileVC.delegate = self;
    otherProfileVC.contact = contact;
    if ([self.parentController respondsToSelector:@selector(pushViewController:)]) {
        [self.parentController performSelector:@selector(pushViewController:) withObject:otherProfileVC];
    }
    [otherProfileVC release];
}

#pragma mark - contact view 

- (void)showContactView
{
    PopContactView *contactView = [[[NSBundle mainBundle] loadNibNamed:@"PopContactView" owner:nil options:nil] lastObject];
    contactView.delegate = self;
    [contactView showInView:kAppDelegate.window];

}

- (void)popContactViewChat:(Contact *)contact
{

}

- (void)popContactViewTel:(Contact *)contact
{
    NSString *tel = [Utility deCryptTel:contact.tel withUserId:contact.userid];
    [Utility callContact:tel];
}

#pragma mark - refresh data

- (void)refreshAction
{
    [self.contactDict removeAllObjects];
    [self.sectionArray removeAllObjects];
    [self initContactDict];
    [self getFriendData];
}

#pragma mark - friend delegate

- (void)otherProfileFriendRefresh    //从他的主页删除好友时 回调
{
    [self refreshAction];
}

#pragma mark - notify

- (void)cityChanged:(NSNotification *)noti
{
    [self refreshAction];
}


@end
