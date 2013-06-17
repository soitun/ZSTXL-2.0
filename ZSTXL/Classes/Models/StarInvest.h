//
//  StarInvest.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-17.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StarInvest : NSManagedObject

@property (nonatomic, retain) NSString * investmentid;
@property (nonatomic, retain) NSString * productname;
@property (nonatomic, retain) NSString * placename;
@property (nonatomic, retain) NSString * creditlevel;
@property (nonatomic, retain) NSString * investmentimgurl;
@property (nonatomic, retain) NSString * createtime;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * ismember;
@property (nonatomic, retain) NSString * isvip;
@property (nonatomic, retain) NSString * companyname;
@property (nonatomic, retain) NSString * username;

@end
