//
//  MailTransmitViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-16.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mail.h"

@interface MailTransmitViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *receiverLabel;
@property (retain, nonatomic) IBOutlet UIButton *addFriendButton;
@property (retain, nonatomic) IBOutlet UITextField *subjectTextField;
@property (retain, nonatomic) IBOutlet UIWebView *contentWebView;

@property (retain, nonatomic) Mail *mail;

@end
