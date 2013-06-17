//
//  Mail.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-17.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mail : NSManagedObject

@property (nonatomic, retain) NSString * answered;
@property (nonatomic, retain) NSString * bcc;
@property (nonatomic, retain) NSString * cc;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * deleted;
@property (nonatomic, retain) NSString * draft;
@property (nonatomic, retain) NSString * flagged;
@property (nonatomic, retain) NSString * hasAttachment;
@property (nonatomic, retain) NSString * localDeleted;
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSString * messageNumber;
@property (nonatomic, retain) NSString * recent;
@property (nonatomic, retain) NSString * seen;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSString * sentDate;
@property (nonatomic, retain) NSString * sentDateStr;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * folderName;

@end
