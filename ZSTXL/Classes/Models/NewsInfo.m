//
//  NewsInfo.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "NewsInfo.h"


@implementation NewsInfo

@dynamic newsid;
@dynamic title;
@dynamic subtitle;
@dynamic type;
@dynamic pictureurl;
@dynamic publishedtime;
@dynamic sortid;


//sortid 不在这两个方法内使用
- (void)initWithDict:(NSDictionary *)dict
{
    self.newsid = [dict objectForKey:@"id"];
    self.title = [dict objectForKey:@"informationtitle"];
    self.subtitle = [dict objectForKey:@"informationtitle2"];
    self.pictureurl = [[[dict objForKey:@"pictureurl"] componentsSeparatedByString:@"/"] lastObject];
    self.publishedtime = [dict objForKey:@"publishedtime"];
    self.sortid = @"";  //默认值
}

- (NSDictionary *)toDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.newsid forKey:@"id"];
    [dict setObject:self.title forKey:@"informationtitle"];
    [dict setObject:self.subtitle forKey:@"informationtitle2"];
    [dict setObject:self.pictureurl forKey:@"pictureurl"];
    [dict setObject:self.publishedtime forKey:@"publishedtime"];
    return dict;
}

@end
