//
//  MailWriteViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailWriteViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *reveiverLabel;
@property (retain, nonatomic) IBOutlet UITextField *subjectTextField;
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;

@end
