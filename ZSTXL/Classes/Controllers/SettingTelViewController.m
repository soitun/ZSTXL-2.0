//
//  SettingTelViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-28.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingTelViewController.h"

@interface SettingTelViewController ()

@end

@implementation SettingTelViewController

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
    self.title = @"手机号码";
    
    [self.authCodeButton addTarget:self action:@selector(getAuthCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saveTel:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_telTextField release];
    [_authCodeButton release];
    [_authCodeTextField release];
    [_saveButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTelTextField:nil];
    [self setAuthCodeButton:nil];
    [self setAuthCodeTextField:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
}

#pragma mark - button method

- (void)getAuthCode:(UIButton *)sender
{
    DLog(@"get auth code");
}

- (void)saveTel:(UIButton *)sender
{
    DLog(@"save tel");
}

@end
