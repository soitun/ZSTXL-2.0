//
//  PublishQueryViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishQueryViewController.h"
#import "PublishZhaoshangViewController.h"

@interface PublishQueryViewController ()

@end

@implementation PublishQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布招商信息";
    self.view.backgroundColor = bgGreyColor;
    self.scrollView.hidden = YES;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self initNavBar];
    
    [self.leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_leftButton release];
    [_rightButton release];
    [_pharNameLabel release];
    [_producerLabel release];
    [_drugFormLabel release];
    [_specLabel release];
    [_orientationTextView release];
    [_drugNumTextField release];
    [_scrollView release];
    [_sepImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLeftButton:nil];
    [self setRightButton:nil];
    [self setPharNameLabel:nil];
    [self setProducerLabel:nil];
    [self setDrugFormLabel:nil];
    [self setSpecLabel:nil];
    [self setOrientationTextView:nil];
    [self setDrugNumTextField:nil];
    [self setScrollView:nil];
    [self setSepImage:nil];
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

#pragma mark - button method

- (void)leftAction
{
    //查询
    [self.drugNumTextField resignFirstResponder];
    if (![self.drugNum isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入药品准字号" andImageName:kErrorIcon];
        return;
    }
    
    NSDictionary *para = @{@"path": @"getDrugCommName.json",
                           @"approvalnumber": self.drugNum};
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            
//        DrugCommView: {
//            id: "234770",
//        commname: "黛蛤散",
//        companyname: "上海雷允上药业有限公司",
//        dosage: "散剂",
//        standard: "每袋装500g",
//        indication: "清热利肺，降逆除烦。用于肝肺实热，头晕耳鸣，咳嗽吐衄，肺痿肺痈，咽膈不利，口渴心烦"
//        },
            
            self.queryFinished = YES;
            self.scrollView.hidden = NO;
            self.sepImage.hidden = NO;
            DLog(@"json %@", json);
            
            NSDictionary *drugDict = [json objForKey:@"DrugCommView"];
            
            self.drugId = [NSString stringWithFormat:@"%d", [[drugDict objForKey:@"id"] intValue]];
            self.productName = [drugDict objForKey:@"commname"];
            
            self.pharNameLabel.text = [drugDict objForKey:@"commname"]; 
            self.producerLabel.text = [drugDict objForKey:@"companyname"];
            self.producer = [drugDict objForKey:@"companyname"];
            self.drugFormLabel.text = [drugDict objForKey:@"dosage"];
            self.specLabel.text = [drugDict objForKey:@"standard"];
            self.orientationTextView.text = [drugDict objForKey:@"indication"];
            
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)rightAction
{
    if (self.queryFinished == NO) {
        [kAppDelegate showWithCustomAlertViewWithText:@"尚未取得药品信息，请重新查询" andImageName:kErrorIcon];
        return;
    }
    
    PublishZhaoshangViewController *publishZhaoshangVC = [[PublishZhaoshangViewController alloc] init];
    publishZhaoshangVC.drugId = self.drugId;
    publishZhaoshangVC.productName = self.productName;
    publishZhaoshangVC.drugNum = self.drugNum;
    publishZhaoshangVC.producer = self.producer;
    
    [self.navigationController pushViewController:publishZhaoshangVC animated:YES];
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.drugNum = textField.text;
}

@end
