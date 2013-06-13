//
//  BlacklistViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "BlacklistViewController.h"
#import "ContactCell.h"
#import "OtherProfileViewController.h"

@interface BlacklistViewController ()

@end

@implementation BlacklistViewController

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
    self.title = @"黑名单";
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
    NSDictionary *para = @{@"path": @"getBlackUserList.json",
                           @"userid": kAppDelegate.userId};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        DLog(@"%@", json);
        if (RETURNCODE_ISVALID(json)) {
            
            NSArray *array = [json objForKey:@"DataList"];
            for (NSDictionary *dict in array) {
                [self.dataSourceArray addObject:dict];
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
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
//    cell.delegate = self;
//    cell.contact = [self makeContactWithDict:dict];
//    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    switch ([[dict objForKey:@"invagency"] intValue]) {
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
    [cell.headIcon setImageWithURL:[NSURL URLWithString:[dict objForKey:@"picturelinkurl"]] placeholderImage:[UIImage imageByName:@"avatar"]];
    
    cell.nameLabel.text = [dict objForKey:@"username"];
    cell.cityLabel.text = [dict objForKey:@"areaname"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    OtherProfileViewController *otherProfileVC =[[[OtherProfileViewController alloc] init] autorelease];
    otherProfileVC.contact = [self makeContactWithDict:dict];
    [self.navigationController pushViewController:otherProfileVC animated:YES];
}

#pragma mark - helper

- (Contact *)makeContactWithDict:(NSDictionary *)dict
{
    Contact *contact = [Contact createEntity];
    contact.areaname = [dict objForKey:@"areaname"];
    contact.prefercontent = [dict objForKey:@"prefercontent"];
    contact.userid = [[dict objForKey:@"blackuserid"] stringValue];
    contact.invagency = [[dict objForKey:@"invagency"] stringValue];
    contact.picturelinkurl = [dict objForKey:@"picturelinkurl"];
    contact.username = [dict objForKey:@"username"];
    contact.username_p = makePinYinOfName(contact.username);
    contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
    contact.cityid = [PersistenceHelper dataForKey:kCityId];
    return contact;
}

@end
