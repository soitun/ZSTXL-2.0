//
//  MessageRecord.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-19.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageRecord : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * loginid;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * time;

@end
