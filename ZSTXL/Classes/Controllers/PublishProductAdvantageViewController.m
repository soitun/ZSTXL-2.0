//
//  PublishProductAdvantageViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishProductAdvantageViewController.h"

@interface PublishProductAdvantageViewController ()

@end

@implementation PublishProductAdvantageViewController

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
    self.title = @"产品性质";
    self.titleArray = @[@"国家医保", @"独家品种", @"基药", @"中标产品", @"有广告支持", @"专利产品", @"市场保护", @"年终返利", @"有培训", @"无需保证金", @"有退货机制"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)para
{
    NSDictionary *para = @{@"path": @"getSalesDirection.json",
                           @"type": @"3"};
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
