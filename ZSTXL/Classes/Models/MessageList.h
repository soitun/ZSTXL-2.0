//
//  MessageList.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-19.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageList : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * count;
@property (nonatomic, retain) NSString * createtime;
@property (nonatomic, retain) NSString * loginid;
@property (nonatomic, retain) NSString * picturelinkurl;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * username;

@end
