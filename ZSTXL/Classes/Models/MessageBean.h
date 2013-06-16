//
//  MessageBean.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-16.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageBean : NSObject

//"answered": false,
//"content": {
//    "text": "好多图"
//},
//"deleted": false,
//"draft": false,
//"flagged": false,
//"hasAttachment": false,
//"messageNumber": 0,
//"recent": false,
//"seen": false,
//"sender": "109981@boramail.com",
//"subject": "转发:好多图",
//"to": [
//       "109981@boramail.com"
//       ]

@property (retain, nonatomic) NSString *answered;
@property (retain, nonatomic) NSDictionary *content;
@property (retain, nonatomic) NSString *deleted;
@property (retain, nonatomic) NSString *draft;
@property (retain, nonatomic) NSString *flagged;
@property (retain, nonatomic) NSString *hasAttachment;
@property (retain, nonatomic) NSString *messageNumber;
@property (retain, nonatomic) NSString *recent;
@property (retain, nonatomic) NSString *seen;
@property (retain, nonatomic) NSString *sender;
@property (retain, nonatomic) NSString *subject;
@property (retain, nonatomic) NSArray *to;

@end
