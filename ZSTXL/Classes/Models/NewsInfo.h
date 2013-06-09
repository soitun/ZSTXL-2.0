//
//  NewsInfo.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewsInfo : NSManagedObject

@property (nonatomic, retain) NSString * newsid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * pictureurl;
@property (nonatomic, retain) NSString * publishedtime;
@property (nonatomic, retain) NSString * sortid;

- (void)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)toDict;

@end
