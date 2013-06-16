//
//  MailInfoViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailNextPreView.h"
#import "Mail.h"

@protocol MailInfoViewControllerDelegate <NSObject>

- (void)mailInfoHasRead:(Mail *)mail;
- (void)mailInfoHasDelete:(Mail *)mail;

@end

@interface MailInfoViewController : UIViewController <MailNextPreViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (retain, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *reveiverNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIWebView *mailWebView;



- (IBAction)mailTransmit:(UIButton *)sender;
- (IBAction)mailDelete:(UIButton *)sender;
- (IBAction)mailWrite:(UIButton *)sender;

@property (retain, nonatomic) Mail *mail;
@property (retain, nonatomic) NSMutableArray *mailArray;
@property (assign, nonatomic) BOOL isInbox;
@property (assign, nonatomic) id<MailInfoViewControllerDelegate> delegate;

@end
