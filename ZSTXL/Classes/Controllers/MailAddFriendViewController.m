//
//  MailAddFriendViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-17.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailAddFriendViewController.h"
#import "FriendContact.h"
#import "ContactCell.h"

@interface MailAddFriendViewController ()

@end

@implementation MailAddFriendViewController

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
    self.title = @"选择好友";
    
    [self initNavBar];
    self.dataSourceArray = [NSMutableArray array];
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

#pragma mark - request Data

- (void)requestData
{
    //取好友数据
    NSArray *array = [FriendContact findAll];
    if (array.count == 0) {
        [self getFriedContactFromNet];
    }
    else{
        [self.dataSourceArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
}

- (void)getFriedContactFromNet
{
    NSDictionary *para = @{@"path": @"getZsAttentionUserByArea.json",
                           @"cityid": [PersistenceHelper dataForKey:kCityId],
                           @"provinceid": [PersistenceHelper dataForKey:kProvinceId],
                           @"userid": kAppDelegate.userId};
    
    
    
    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            

            NSArray *friendArray = [Utility deCryptJsonDict:json OfJsonKey:@"DataList"];

            
            [friendArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                //                NSLog(@"contact Dict: %@", contactDict);
                
                FriendContact *contact = [FriendContact createEntity];
                [contact initWithDict:contactDict];
                contact.areaname = [contactDict objForKey:@"areaname"];
                contact.type = @"1";
                [self.dataSourceArray addObject:contact];
                DB_SAVE();
            }];
            
            [self.tableView reloadData];
            
        } else {
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
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
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ContactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] lastObject];
    }
    
    FriendContact *contact = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.contact = contact;
    
    [cell refresh];
    cell.cityLabel.text = ((FriendContact *)contact).areaname;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendContact *contact = [self.dataSourceArray objectAtIndex:indexPath.row];
    PERFORM_SELECTOR_WITH_OBJECT(self.delegate, @selector(mailAddFriend:), contact);
    [self popVC:nil];
}

@end
