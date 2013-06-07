//
//  PublishDailiAdvantageViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishDailiAdvantageViewController.h"

@interface PublishDailiAdvantageViewController ()

@end

@implementation PublishDailiAdvantageViewController

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
    self.title = @"代理优势";
    
    [self initNavBar];
    
    self.view.backgroundColor = bgGreyColor;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 289-10, 100)];
    [self.textField setFont:[UIFont systemFontOfSize:16]];
    self.textField.text = @"请输入产品优势";
    [self.textField setTextColor:[UIColor grayColor]];
    self.textField.delegate = self;
    
    
    
    UIImage *textFieldBgImage = [UIImage stretchableImage:@"setting_textfield_bg" leftCap:0 topCap:5];
    self.textFieldBg = [[UIImageView alloc] initWithImage:textFieldBgImage];
    self.textFieldBg.userInteractionEnabled = YES;
    self.textFieldBg.frame = CGRectMake(15, 20, 289, 120);
    [self.textFieldBg addSubview:self.textField];
    [self.view addSubview:self.textFieldBg];
    
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmFooterView" owner:nil options:nil] lastObject];
    self.footer.frame = CGRectMake(0, 140, 320, 240);
    self.footer.delegate = self;
    [self.view addSubview:self.footer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

#pragma mark - confirm footer

- (void)confirmFooterViewLeftAction
{
    [self.textField resignFirstResponder];
    if ([self.dailiAdvantage isEqualToString:@"请输入产品优势"]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入产品优势" andImageName:kErrorIcon];
        return;
    }
    PERFORM_SELECTOR_WITH_OBJECT(self.delegate, @selector(publishDailiAdvantageFinish:), self.dailiAdvantage);
    [self popVC:nil];
}

- (void)confirmFooterViewRightAction
{
    [self popVC:nil];
}

#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setTextColor:[UIColor blackColor]];
    textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isValid]) {
        textField.text = @"请输入产品优势";
        [textField setTextColor:[UIColor grayColor]];
    }
    else{
        self.dailiAdvantage = textField.text;
    }
}

@end
