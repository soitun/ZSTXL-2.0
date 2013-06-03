//
//  MailInfoViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailNextPreView.h"

@interface MailInfoViewController : UIViewController <MailNextPreViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (retain, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *senderMailLabel;
@property (retain, nonatomic) IBOutlet UILabel *reveiverNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *receiverMailLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UITextView *mailContentTextView;
- (IBAction)mailTransmit:(UIButton *)sender;
- (IBAction)mailDelete:(UIButton *)sender;
- (IBAction)mailWrite:(UIButton *)sender;


@end
