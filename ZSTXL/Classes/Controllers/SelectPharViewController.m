//
//  SelectPharViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-5.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SelectPharViewController.h"
#import "PharCell.h"

@interface SelectPharViewController ()

@end

@implementation SelectPharViewController

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
    self.title = @"选择偏好";
    self.selectArray = [NSMutableArray array];
    self.dataSourceArray = [NSMutableArray array];
    
    [self initNavBar];
    [self requestPharData];
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
    
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:[UIImage imageNamed:@"nav_login_button"] forState:UIControlStateNormal];
    [rButton setBackgroundImage:[UIImage imageNamed:@"nav_login_button_p"] forState:UIControlStateHighlighted];
    [rButton setTitle:@"确认" forState:UIControlStateNormal];
    [rButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [rButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(selectFinished) forControlEvents:UIControlEventTouchUpInside];
    rButton.frame = CGRectMake(0, 0, 54, 32);
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:rButton] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectFinished
{
    PERFORM_SELECTOR_WITH_OBJECT(self.delegate, @selector(selectPharFinished:), self.selectArray);
    [self popVC:nil];
}

#pragma mark - phar info

- (void)requestPharData
{
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getPharmacologyClassify.json", @"path", nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取药品类别";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        NSArray *pharArray = [json objectForKey:@"PharmacologyList"];
        [pharArray enumerateObjectsUsingBlock:^(NSDictionary *pharDict, NSUInteger idx, BOOL *stop) {
            NSDictionary *dict = @{@"pharid": [[pharDict objForKey:@"id"] stringValue],
                                   @"content": [pharDict objForKey:@"content"],
                                   };
            [self.dataSourceArray addObject:dict];
        }];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - tableview

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
    return 51.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"PharCell";
    PharCell *cell = (PharCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PharCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [dict objForKey:@"content"];
    if ([self.selectArray containsObject:dict]) {
        cell.selectImage.image = [UIImage imageByName:@"login_select"];
    }
    else{
        cell.selectImage.image = [UIImage imageByName:@"login_noselect"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    if ([self.selectArray containsObject:dict]) {
        [self.selectArray removeObject:dict];
    }
    else{
        if (self.selectArray.count == 2) {
            [kAppDelegate showWithCustomAlertViewWithText:@"最多选择两个类别" andImageName:kErrorIcon];
            return;
        }
        [self.selectArray addObject:dict];
    }
    
    [self.tableView reloadData];
}


@end
