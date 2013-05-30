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
#import "OtherHomepageViewController.h"

@interface FriendContactViewController ()

@end

@implementation FriendContactViewController

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
    self.dataSourceArray = [NSMutableArray array];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self initContactDict];
    [self getFriendData];
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
            
            NSLog(@"section array %@", self.sectionArray);
            [self.tableView reloadData];
        }
        else{
            [self getInvestmentUserListFromServer];
        }
    }
}

- (void)getInvestmentUserListFromServer
{
    [PersistenceHelper setData:@"北京" forKey:kCityName];
    NSString *cityName = [PersistenceHelper dataForKey:kCityName];
    NSString *cityId = [[Utility getCityIdByCityName:cityName] cityId];
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
                contact.type = @"1";
                contact.username_p = makePinYinOfName(contact.username);
                contact.invagency = [[contactDict objForKey:@"invagency"] stringValue];
                
                
                //                NSLog(@"pinyin %@", makePinYinOfName(contact.username));
                
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
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
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
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
            cell.ZDLabel.text = @"招商、代理";
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
    
    cell.unSelectedImage.hidden = YES;
    
    if ([userDetail.col2 isEqualToString:@"1"]) {
        cell.xun_VImage.hidden = NO;
    }
    else{
        cell.xun_VImage.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherHomepageViewController *otherProfileVC = [[OtherHomepageViewController alloc] init];
    
    NSString *sectionKey = [self.sectionArray objectAtIndex:indexPath.section];
    Contact *contact = [[self.contactDict objectForKey:sectionKey] objectAtIndex:indexPath.row];
    
    
    otherProfileVC.contact = contact;
    if ([self.parentController respondsToSelector:@selector(pushViewController:)]) {
        [self.parentController performSelector:@selector(pushViewController:) withObject:otherProfileVC];
    }
    [otherProfileVC release];;
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
@end
