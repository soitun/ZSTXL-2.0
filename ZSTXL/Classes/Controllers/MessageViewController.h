//
//  MessageViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface MessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HPGrowingTextViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIButton *doneButton;
@property (copy,   nonatomic) NSString *lastTime;
@property (retain, nonatomic) NSTimer *timer;
@property (retain, nonatomic) UIView *containerView;
@property (retain, nonatomic) HPGrowingTextView *textView;


@property (retain, nonatomic) NSMutableArray *dataSourceArray;

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *avatarUrl;
@property (copy, nonatomic) NSString *content;

@property (assign, nonatomic) BOOL isDB;

@property (assign, nonatomic) NSInteger page;
@property (copy, nonatomic) NSString *maxrow;

- (NSDictionary *)talkHistoryPara;
- (NSDictionary *)getMessageLoopPara;
- (NSDictionary *)addMessagePara;


@end
