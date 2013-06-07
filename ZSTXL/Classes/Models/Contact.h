//
//  Contact.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-7.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * autograph;
@property (nonatomic, retain) NSString * cityid;
@property (nonatomic, retain) NSString * col1;
@property (nonatomic, retain) NSString * col2;
@property (nonatomic, retain) NSString * col3;
@property (nonatomic, retain) NSString * invagency;
@property (nonatomic, retain) NSString * isreal;
@property (nonatomic, retain) NSString * loginid;
@property (nonatomic, retain) NSString * mailbox;
@property (nonatomic, retain) NSString * picturelinkurl;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * sectionkey;
@property (nonatomic, retain) NSString * sortid;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * username_p;
@property (nonatomic, retain) NSString * ismember;
@property (nonatomic, retain) NSString * creditlevel;
@property (nonatomic, retain) NSString * prefercontent;

-(void)initWithDict:(NSDictionary *)dict;


@end
