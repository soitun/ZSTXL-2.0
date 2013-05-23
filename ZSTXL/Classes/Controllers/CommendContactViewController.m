//
//  CommendContactViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "CommendContactViewController.h"
#import "CommendContact.h"
#import "ContactCell.h"
#import "OtherHomepageViewController.h"

@interface CommendContactViewController ()

@end

@implementation CommendContactViewController

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
    self.commendContactArray = [NSMutableArray array];
    [self getCommendData];
}

- (void)getCommendData
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@ AND cityid == %@", kAppDelegate.userId, [PersistenceHelper dataForKey:kCityId]];
    [self.commendContactArray addObjectsFromArray:[CommendContact findAllSortedBy:@"sortid" ascending:YES withPredicate:pred]];
    if (self.commendContactArray.count == 0) {
        [self getInvestmentUserListFromServer];
    }
    else{
        [self.tableView reloadData];
    }
}

- (void)getInvestmentUserListFromServer
{
    [PersistenceHelper setData:@"北京" forKey:kCityName];
    
    NSString *cityId = [[Utility getCityIdByCityName:[PersistenceHelper dataForKey:kCityName]] cityId];
    NSString *proId = [[Utility getCityIdByCityName:[PersistenceHelper dataForKey:kCityName]] proId];
    
    NSString *userid = kAppDelegate.userId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:proId, @"provinceid",
                          cityId, @"cityid",
                          userid, @"userid",
                          @"getZsRrecommendList.json", @"path", nil];
    
    
    NSLog(@"all contact dict %@", dict);
    
    
    __block int sortid = 0;
    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            //            NSLog(@"friend json %@", json);
            
            NSArray *friendArray = [Utility deCryptJsonDict:json OfJsonKey:@"DataList"];
            NSLog(@"friend arrat %@", friendArray);
            [friendArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                NSLog(@"contact Dict: %@", contactDict);
                
                CommendContact *contact = [CommendContact MR_createEntity];
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
                contact.sortid = [NSString stringWithFormat:@"%d", sortid];
                sortid++;
                
                NSLog(@"pinyin %@", makePinYinOfName(contact.username));
                
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                [self.commendContactArray addObject:contact];
                DB_SAVE();
            }];
            
            [self.tableView reloadData];
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commendContactArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"contactCell";
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
    
    
    CommendContact *commendContact = [self.commendContactArray objectAtIndex:indexPath.row];
    
    switch (commendContact.invagency.intValue) {
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
    [cell.headIcon setImageWithURL:[NSURL URLWithString:commendContact.picturelinkurl] placeholderImage:[UIImage imageByName:@"avatar"]];
    
    if ([commendContact.remark isValid]) {
        NSMutableString *userName = [NSMutableString stringWithFormat:@"%@(%@)", commendContact.username, commendContact.remark];
        cell.nameLabel.text = userName;
    }
    else{
        cell.nameLabel.text = commendContact.username;
    }
    
    if ([commendContact.col2 isEqualToString:@"1"]) {
        cell.xun_VImage.hidden = NO;
    }
    else{
        cell.xun_VImage.hidden = YES;
    }
    
    cell.unSelectedImage.hidden = YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherHomepageViewController *otherProfileVC = [[OtherHomepageViewController alloc] init];
    
    otherProfileVC.contact = [self.commendContactArray objectAtIndex:indexPath.row];
    if ([self.parentController respondsToSelector:@selector(pushViewController:)]) {
        [self.parentController performSelector:@selector(pushViewController:) withObject:otherProfileVC];
    }
    [otherProfileVC release];
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
