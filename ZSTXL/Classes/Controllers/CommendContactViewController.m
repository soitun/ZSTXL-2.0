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
#import "OtherProfileViewController.h"

@interface CommendContactViewController ()

@end

@implementation CommendContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:kCityChangedNoification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.commendContactArray = [NSMutableArray array];
    [self getCommendData];
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
    NSString *cityId = [PersistenceHelper dataForKey:kCityId];
    NSString *proId = [PersistenceHelper dataForKey:kProvinceId];
    
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
                [contact initWithDict:contactDict];
                contact.sortid = [NSString stringWithFormat:@"%d", sortid];
                sortid++;
                
                NSLog(@"pinyin %@", makePinYinOfName(contact.username));
                
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                [self.commendContactArray addObject:contact];
                DB_SAVE();
            }];
            
            if (self.commendContactArray.count == 0) {
                self.getContactFinsh = YES;
            }
            
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
    static NSString *cellID = @"ContactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
    }
    Contact *contact = [self.commendContactArray objectAtIndex:indexPath.row];
    cell.contact = contact;
    cell.delegate = self;
    [cell refresh];
    
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;
    cell.contact = [self.commendContactArray objectAtIndex:indexPath.row];
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
            cell.ZDLabel.text = @"招商/代理";
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
    
//    if ([commendContact.col2 isEqualToString:@"1"]) {
//        cell.xun_VImage.hidden = NO;
//    }
//    else{
//        cell.xun_VImage.hidden = YES;
//    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact *contact = [self.commendContactArray objectAtIndex:indexPath.row];
    PopContactView *pop = [[PopContactView alloc] initWithNib:@"PopContactView"];
    pop.delegate = self;
    pop.contact = contact;
    [pop showInView:kAppDelegate.window];
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
    if (!self.getContactFinsh) {
        [self.commendContactArray removeAllObjects];
        [self getCommendData];
    }
}

#pragma mark - notify

- (void)cityChanged:(NSNotification *)noti
{
    self.getContactFinsh = NO;
    [self refreshAction];
}

@end
