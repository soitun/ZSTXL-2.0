//
//  self.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-7.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "Contact.h"


@implementation Contact

@dynamic autograph;
@dynamic cityid;
@dynamic col1;
@dynamic col2;
@dynamic col3;
@dynamic invagency;
@dynamic isreal;
@dynamic loginid;
@dynamic mailbox;
@dynamic picturelinkurl;
@dynamic remark;
@dynamic sectionkey;
@dynamic sortid;
@dynamic tel;
@dynamic type;
@dynamic userid;
@dynamic username;
@dynamic username_p;
@dynamic ismember;
@dynamic creditlevel;
@dynamic prefercontent;

- (void)initWithDict:(NSDictionary *)dict
{
    self.userid = [[dict objForKey:@"id"] stringValue];
    self.username = [dict objForKey:@"username"];
    self.tel = [dict objForKey:@"tel"];
    self.mailbox = [dict objForKey:@"mailbox"];
    self.picturelinkurl = [dict objForKey:@"picturelinkurl"];
    self.col1 = [dict objForKey:@"col1"];
    self.col2 = [dict objForKey:@"col2"];
    self.col2 = [dict objForKey:@"col2"];
    self.cityid = [PersistenceHelper dataForKey:kCityId];
    self.loginid = [kAppDelegate userId];
    self.username_p = makePinYinOfName(self.username);
    self.invagency = [[dict objForKey:@"invagency"] stringValue];
    self.prefercontent = [dict objForKey:@"prefercontent"];
    self.ismember = [[dict objForKey:@"ismember"] stringValue];
    self.creditlevel = [dict objForKey:@"creditlevel"];
    self.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([self.username characterAtIndex:0])];
}

@end
