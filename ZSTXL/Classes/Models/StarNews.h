//
//  StarNews.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-17.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StarNews : NSManagedObject

@property (nonatomic, retain) NSString * newsid;
@property (nonatomic, retain) NSString * informationtitle;
@property (nonatomic, retain) NSString * informationtitle2;
@property (nonatomic, retain) NSString * publishedtime;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * pictureurl;
@property (nonatomic, retain) NSString * groupid;
@property (nonatomic, retain) NSString * createid;
@property (nonatomic, retain) NSString * count;
@property (nonatomic, retain) NSString * sort;
@property (nonatomic, retain) NSString * type;

@end
