//
//  AddMeViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "AddMeViewController.h"
#import "HomePageCell.h"
#import "Contact.h"
#import "FriendContact.h"
#import "OtherProfileViewController.h"

@interface AddMeViewController ()

@end

@implementation AddMeViewController

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
    self.title = @"加我为好友的人";
    self.view.backgroundColor = bgGreyColor;
    self.dataSourceArray = [NSMutableArray array];
    
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

#pragma mark - request data

- (void)requestData
{
    NSDictionary *para = @{@"path": @"getAttentionMyUserData.json",
                           @"userid": kAppDelegate.userId};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        DLog(@"%@", json);
        if (RETURNCODE_ISVALID(json)) {
            
            NSArray *array = [json objForKey:@"DataList"];
            for (NSDictionary *dict in array) {
                
                Contact *contact = [self makeContactWithDict:dict];
                [self.dataSourceArray addObject:contact];
            }
            
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
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

#pragma mark - table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ContactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Contact *contact = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.contact = contact;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    switch ([contact.invagency intValue]) {
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
    [cell.headIcon setImageWithURL:[NSURL URLWithString:contact.picturelinkurl] placeholderImage:[UIImage imageByName:@"avatar"]];
    
    cell.nameLabel.text = contact.username;
    cell.cityLabel.text = contact.areaname;
    
    NSInteger type = contact.type.integerValue;
    if (type == 1) {
        cell.addFriendButton.hidden = NO;
    }
    else{
        cell.addFriendButton.hidden = YES;
        cell.haveAddLabel.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopContactView *contactView = [[PopContactView alloc] initWithNib:@"PopContactView"];
    contactView.contact = [self.dataSourceArray objectAtIndex:indexPath.row];
    contactView.delegate = self;
    [contactView showInView:kAppDelegate.window];
}

- (Contact *)makeContactWithDict:(NSDictionary *)dict
{
    Contact *contact = [Contact createEntity];
    contact.areaname = [dict objForKey:@"areaname"];
    contact.prefercontent = [dict objForKey:@"prefercontent"];
    contact.userid = [dict objForKey:@"attentionuserid"];
    contact.invagency = [[dict objForKey:@"invagency"] stringValue];
    contact.picturelinkurl = [dict objForKey:@"picturelinkurl"];
    contact.username = [dict objForKey:@"username"];
    contact.username_p = makePinYinOfName(contact.username);
    contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
    contact.cityid = [PersistenceHelper dataForKey:kCityId];
    return contact;
}

#pragma mark - cell delegate

- (void)contactCellAddFriend:(Contact *)contact atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *para = @{@"path": @"addZsAttentionUser.json",
                           @"userid": kAppDelegate.userId,
                           @"attentionid": contact.userid,
                           @"provinceid": [PersistenceHelper dataForKey:kProvinceId],
                           @"cityid": [PersistenceHelper dataForKey:kCityId]};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    hud.labelText = @"加为好友";
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            [self updateContact:contact IsFriend:YES];
            ContactCell *cell = (ContactCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.addFriendButton.hidden = YES;
            cell.haveAddLabel.hidden = NO;
            
        }else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)contactCellTapAvatarOfContact:(Contact *)contact
{
    OtherProfileViewController *otherProfileVC =[[[OtherProfileViewController alloc] init] autorelease];
    otherProfileVC.contact = contact;
    [self.navigationController pushViewController:otherProfileVC animated:YES];
}


#pragma mark - contact view

- (void)popContactViewChat:(Contact *)contact
{
    
}

- (void)popContactViewTel:(NSString *)tel
{
    [Utility callContact:tel];
}

- (void)popContactViewTapAvatar:(Contact *)contact
{
    OtherProfileViewController *otherProfileVC =[[[OtherProfileViewController alloc] init] autorelease];
    otherProfileVC.contact = contact;
    [self.navigationController pushViewController:otherProfileVC animated:YES];
}

#pragma mark - add friend

- (void)updateContact:(Contact *)contact IsFriend:(BOOL)isFriend
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userid == %@ AND loginid == %@ AND cityid == %@", contact.userid, [kAppDelegate userId], [PersistenceHelper dataForKey:kCityId]];
    FriendContact *friendContact = [FriendContact findFirstWithPredicate:pred];
    if (friendContact == nil) {
        friendContact = [FriendContact createEntity];
        friendContact.autograph = contact.autograph;
        friendContact.cityid = [PersistenceHelper dataForKey:kCityId];
        friendContact.col1 = contact.col1;
        friendContact.col2 = contact.col2;
        friendContact.col3 = contact.col3;
        friendContact.invagency = contact.invagency;
        friendContact.loginid = kAppDelegate.userId;
        friendContact.mailbox = contact.mailbox;
        friendContact.picturelinkurl = contact.picturelinkurl;
        //        friendContact.remark = self.commentTextField.text;
        friendContact.sectionkey = contact.sectionkey;
        friendContact.tel = contact.tel;
        friendContact.userid = contact.userid;
        friendContact.username = contact.username;
        friendContact.username_p = contact.username_p;
    }
    
    DB_SAVE();
    
}

@end
