//
//  Contact.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "Contact.h"


@implementation Contact

@dynamic autograph;
@dynamic cityid;
@dynamic col1;
@dynamic col2;
@dynamic col3;
@dynamic creditlevel;
@dynamic invagency;
@dynamic ismember;
@dynamic isreal;
@dynamic loginid;
@dynamic mailbox;
@dynamic picturelinkurl;
@dynamic prefercontent;
@dynamic remark;
@dynamic sectionkey;
@dynamic sortid;
@dynamic tel;
@dynamic type;
@dynamic userid;
@dynamic username;
@dynamic username_p;
@dynamic areaname;

- (void)initWithDict:(NSDictionary *)dict
{
    self.loginid = kAppDelegate.userId;
    self.cityid = [PersistenceHelper dataForKey:kCityId];
    self.autograph = [dict objForKey:@"autograph"];
    self.col1 = [dict objForKey:@"col1"];
    self.col2 = [dict objForKey:@"col2"];
    self.col3 = [dict objForKey:@"col3"];
    self.creditlevel = [dict objForKey:@"creditlevel"];
    self.userid = [[dict objForKey:@"id"] stringValue];
    self.invagency = [[dict objForKey:@"invagency"] stringValue];
    self.ismember = [[dict objForKey:@"ismember"] stringValue];
    self.mailbox = [dict objForKey:@"mailbox"];
    self.picturelinkurl = [dict objForKey:@"picturelinkurl"];
    self.tel = [dict objForKey:@"tel"];
    self.username = [dict objForKey:@"username"];
    self.username_p = makePinYinOfName(self.username);
    self.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([self.username characterAtIndex:0])];
}

@end
