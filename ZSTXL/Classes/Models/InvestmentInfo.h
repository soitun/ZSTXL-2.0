//
//  InvestmentInfo.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-14.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InvestmentInfo : NSManagedObject

@property (nonatomic, retain) NSString * infoid;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * investment;
@property (nonatomic, retain) NSString * picturelinkurl;
@property (nonatomic, retain) NSString * stime;
@property (nonatomic, retain) NSString * col4;

@end
