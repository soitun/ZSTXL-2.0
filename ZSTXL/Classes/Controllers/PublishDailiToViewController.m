//
//  PublishDailiToViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishDailiToViewController.h"

@interface PublishDailiToViewController ()

@end

@implementation PublishDailiToViewController

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
    self.title = @"代理方向";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)para
{
    NSDictionary *para = @{@"path": @"getPharmacologyClassify.json"};
    return para;
}

- (void)analyseData:(NSDictionary *)json
{
    NSArray *tmpArray = [json objForKey:@"PharmacologyList"];
    for (NSDictionary *dict in tmpArray) {
        [self.dataSourceArray addObject:dict];
    }
}

- (NSString *)titleNameOfDict:(NSDictionary *)dict
{
    return [dict objForKey:@"content"];
}

@end
