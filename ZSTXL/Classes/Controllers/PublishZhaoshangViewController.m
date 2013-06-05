//
//  PublishZhaoshangViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishZhaoshangViewController.h"
#import "TextFieldCell.h"
#import "SettingCell.h"
#import "PublishCell.h"
#import "CustomCellBackgroundView.h"
#import "PublishSellToViewController.h"
#import "PublishZhaoshangPropertyViewController.h"
#import "PublishProductAdvantageViewController.h"
#import "PublishPeriodViewController.h"

@interface PublishZhaoshangViewController ()

@end

@implementation PublishZhaoshangViewController

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
    self.title = @"发布招商信息";
    self.titleArray = @[@"区域选择：", @"销售方向：", @"招商性质：", @"产品优势：", @"信息有效期："];
    self.selectorArray = @[@"selectArea", @"sellTo", @"canvassProperty", @"productAdvantage", @"infoPeriod"];
    self.navigationController.delegate = self;
    
    self.tableView.backgroundView = nil;
    [self initDrugImage];
    [self initTableFooter];
    [self initNavBar];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [kAppDelegate.tabController hidesTabBar:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_drugImage release];
    [_drugNameLabel release];
    [_drugNumLabel release];
    [_producerLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setDrugImage:nil];
    [self setDrugNameLabel:nil];
    [self setDrugNumLabel:nil];
    [self setProducerLabel:nil];
    [super viewDidUnload];
}

#pragma mark - drug image

- (void)initDrugImage
{
    self.drugImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDrugImage)];
    [self.drugImage addGestureRecognizer:tap];
}

- (void)tapDrugImage
{
    NSLog(@"更换头像");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark - action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex; %d", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.showsCameraControls = YES;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
            break;
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
            break;
        case 2:
            NSLog(@"设置头像取消");
            break;
        default:
            break;
    }
}

#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.drugImage.image=[info valueForKey:UIImagePickerControllerEditedImage];
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - nav back button

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

- (void)initTableFooter
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"setting_confirm_l"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"setting_confirm_l_p"] forState:UIControlStateHighlighted];
    confirmButton.frame = CGRectMake(15, 10, 289, 48);
    [confirmButton addTarget:self action:@selector(confirmPublish:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
    
    [self.tableView setTableFooterView:footerView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *textCellId = @"TextFieldCell";
    static NSString *commonCellId = @"PublishCell";
    
    if (indexPath.section == 0) {
        TextFieldCell *textFieldCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:textCellId];
        if (textFieldCell == nil) {
            textFieldCell = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:nil options:nil] lastObject];
        }
        
        [Utility groupTableView:tableView addBgViewForCell:textFieldCell withCellPos:CustomCellBackgroundViewPositionSingle];
        textFieldCell.accessoryType = UITableViewCellAccessoryNone;
        return textFieldCell;
    }
    else{
        PublishCell *commonCell = (PublishCell *)[tableView dequeueReusableCellWithIdentifier:commonCellId];
        if (commonCell == nil) {
            commonCell = [[[NSBundle mainBundle] loadNibNamed:@"PublishCell" owner:nil options:nil] lastObject];
        }
        
        [Utility groupTableView:tableView addBgViewForCell:commonCell withCellPos:CustomCellBackgroundViewPositionSingle];
        commonCell.nameLabel.text = [self.titleArray objectAtIndex:indexPath.section-1];
        return commonCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"did select");
    if (indexPath.section == 0) {
        
    }
    else{
        SEL sel = NSSelectorFromString([self.selectorArray objectAtIndex:indexPath.section - 1]);
        [self performSelector:sel];
    }
}

#pragma mark - table method

- (void)selectArea
{
    SelectCityViewController *selectCityVC = [[[SelectCityViewController alloc] init] autorelease];
    selectCityVC.delegate = self;
    selectCityVC.allowMultiselect = NO;
    [self.navigationController pushViewController:selectCityVC animated:YES];
}

- (void)sellTo
{
    //销售方向
    DLog(@"sellto");
    PublishSellToViewController *publishSellToVC = [[[PublishSellToViewController alloc] init] autorelease];
    publishSellToVC.type = @"1";
    publishSellToVC.delegate = self;
    publishSellToVC.allowMultiSelect = YES;
    [self.navigationController pushViewController:publishSellToVC animated:YES];
}

- (void)canvassProperty
{
    //招商性质
    PublishZhaoshangPropertyViewController *publishZhaoshangPropertyViewController = [[[PublishZhaoshangPropertyViewController alloc] init] autorelease];
    publishZhaoshangPropertyViewController.type = @"2";
    publishZhaoshangPropertyViewController.delegate = self;
    publishZhaoshangPropertyViewController.allowMultiSelect = YES;
    [self.navigationController pushViewController:publishZhaoshangPropertyViewController animated:YES];
}

- (void)productAdvantage
{
    //产品优势
    PublishProductAdvantageViewController *publishProductAdvantageViewController = [[[PublishProductAdvantageViewController alloc] init] autorelease];
    publishProductAdvantageViewController.type = @"3";
    publishProductAdvantageViewController.delegate = self;
    publishProductAdvantageViewController.allowMultiSelect = YES;
    [self.navigationController pushViewController:publishProductAdvantageViewController animated:YES];
}

- (void)infoPeriod
{
    //信息有效期
    PublishPeriodViewController *publishPeriodViewController = [[[PublishPeriodViewController alloc] init] autorelease];
    publishPeriodViewController.type = @"4";
    publishPeriodViewController.delegate = self;
    publishPeriodViewController.allowMultiSelect = NO;
    [self.navigationController pushViewController:publishPeriodViewController animated:YES];
}

- (void)confirmPublish:(UIButton *)sender
{
//    添加招商信息	/addInvestment.json		image	File	图片	durgid	long	药品ID	productname	String	商品名	proviceid	String	省ID	cityid	String	市ID	countyid	String	县ID（删除）	direction	String	方向	quale	String	招商性质	superiority	String	产品优势	duration	long	时长	userid	long	用户宝通号
    if (![self.drugId isValid] ||
        ![self.productName isValid] ||
        ![self.provinceId isValid] ||
        ![self.cityId isValid] ||
        ![self.direction isValid] ||
        ![self.quale isValid] ||
        ![self.superiority isValid] ||
        ![self.duration isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请完善招商信息" andImageName:kErrorIcon];
        return;
    }
    
    
    UIImage *smallImage = [self.drugImage.image scaleToFillSize:CGSizeMake(80.f, 60.f)];
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.6);

    NSDictionary *para = @{@"durgid": self.drugId,
                           @"productname": self.productName,
                           @"provinceid": self.provinceId,
                           @"cityid": self.cityId,
                           @"direction": self.direction,
                           @"quale": self.quale,
                           @"superiority": self.superiority,
                           @"duration": self.duration,
                           @"userid": kAppDelegate.userId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    hud.labelText = @"发布招商信息";
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        
    }];
    
}

#pragma mark - publish base delegate

- (void)publishSelectFinish:(NSArray *)array withType:(NSString *)type
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[type intValue]+1];
    PublishCell *cell = (PublishCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableString *allContent = [NSMutableString string];
    
    for (NSDictionary *dict in array) {
        [allContent appendFormat:@"%@、", [dict objForKey:@"content"]];
    }
    
    if ([allContent isValid]) {
        allContent = [NSMutableString stringWithString:[allContent substringToIndex:allContent.length-1]];
    }
    
    DLog(@"allcontent %@", allContent);
    cell.contentLabel.text = allContent;
    
    //销售方向，招商性质，产品优势，信息有效期
    switch (type.intValue) {
        case 1:
        {
            self.direction = allContent;
        }
            break;
        case 2:
        {
            self.quale = allContent;
        }
            break;
        case 3:
        {
            self.superiority = allContent;
        }
            break;
        case 4:
        {
            self.duration = [NSString stringWithFormat:@"%d", [[[array lastObject] objForKey:@"col4"] intValue]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - select city delegate

- (void)SelectCityFinished:(NSArray *)array
{
    NSDictionary *city = [array lastObject];
    self.provinceId = [city objForKey:@"provinceid"];
    self.cityId = [city objForKey:@"cityid"];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    PublishCell *cell = (PublishCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.text = [city objForKey:@"cityname"];
}

@end
