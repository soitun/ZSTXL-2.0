//
//  Mail.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-18.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mail : NSManagedObject

@property (nonatomic, retain) NSNumber * answered;
@property (nonatomic, retain) NSString * bcc;
@property (nonatomic, retain) NSString * cc;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * draft;
@property (nonatomic, retain) NSNumber * flagged;
@property (nonatomic, retain) NSString * folderName;
@property (nonatomic, retain) NSNumber * hasAttachment;
@property (nonatomic, retain) NSString * localDeleted;
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSNumber * messageNumber;
@property (nonatomic, retain) NSNumber * recent;
@property (nonatomic, retain) NSNumber * seen;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSNumber * sentDate;
@property (nonatomic, retain) NSString * sentDateStr;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * to;

@end
