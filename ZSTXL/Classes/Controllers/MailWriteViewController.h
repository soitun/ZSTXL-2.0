//
//  MailWriteViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mail.h"
#import "MailAddFriendViewController.h"

@interface MailWriteViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, MailAddFriendViewControllerDelegate, UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *receiverLabel;
@property (retain, nonatomic) IBOutlet UITextField *subjectTextField;
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
@property (retain, nonatomic) IBOutlet UIButton *addFriendButton;
@property (retain, nonatomic) IBOutlet UIImageView *contentImageView;

@property (copy, nonatomic) NSString *subject;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *to;

@end
