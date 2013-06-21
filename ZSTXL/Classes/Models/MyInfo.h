//
//  MyInfo.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CityInfo, Pharmacology, UserDetail;

@interface MyInfo : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * unreadCount;
@property (nonatomic, retain) NSString * unreadMailCount;
@property (nonatomic, retain) NSString * unreadSMSCount;
@property (nonatomic, retain) NSString * attentionMyCount;
@property (nonatomic, retain) NSString * myBlackListCount;
@property (nonatomic, retain) NSString * myCollectCount;
@property (nonatomic, retain) NSString * newAttentInvestCount;




@property (nonatomic, retain) NSSet *areaList;
@property (nonatomic, retain) NSSet *pharList;
@property (nonatomic, retain) UserDetail *userDetail;
@end

@interface MyInfo (CoreDataGeneratedAccessors)

- (void)addAreaListObject:(CityInfo *)value;
- (void)removeAreaListObject:(CityInfo *)value;
- (void)addAreaList:(NSSet *)values;
- (void)removeAreaList:(NSSet *)values;

- (void)addPharListObject:(Pharmacology *)value;
- (void)removePharListObject:(Pharmacology *)value;
- (void)addPharList:(NSSet *)values;
- (void)removePharList:(NSSet *)values;

@end
