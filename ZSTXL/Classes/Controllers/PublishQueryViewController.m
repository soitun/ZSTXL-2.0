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
    
}

- (void)rightAction
{
    PublishZhaoshangViewController *publishZhaoshangVC = [[[PublishZhaoshangViewController alloc] init] autorelease];
    [self.navigationController pushViewController:publishZhaoshangVC animated:YES];
}

@end
