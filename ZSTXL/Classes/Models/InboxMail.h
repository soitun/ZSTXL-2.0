//
//  InboxMail.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InboxMail : NSManagedObject

@property (nonatomic, retain) NSString * sentdate;
@property (nonatomic, retain) NSString * seen;
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSString * sentdatestr;

@end
