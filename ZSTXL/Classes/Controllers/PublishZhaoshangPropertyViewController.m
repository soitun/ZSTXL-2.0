//
//  PublishZhaoshangPropertyViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishZhaoshangPropertyViewController.h"

@interface PublishZhaoshangPropertyViewController ()

@end

@implementation PublishZhaoshangPropertyViewController

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
    self.title = @"招商性质";
    self.titleArray = @[@"个人", @"企业"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)para
{
    NSDictionary *para = @{@"path": @"getSalesDirection.json",
                           @"type": @"2"};
    return para;
}

- (void)analyseData:(NSDictionary *)json
{
    NSArray *tmpArray = [json objForKey:@"InvestmentInfo"];
    for (NSDictionary *dict in tmpArray) {
        [self.dataSourceArray addObject:dict];
    }
}

- (NSString *)titleNameOfDict:(NSDictionary *)dict
{
    return [dict objForKey:@"content"];
}

@end
