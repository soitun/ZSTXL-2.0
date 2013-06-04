//
//  RegistViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *telTextField;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (retain, nonatomic) IBOutlet UILabel *countDownLabel;
@property (nonatomic, assign) NSInteger allowFriendContact;


@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *authCode;
@property (nonatomic, copy) NSDate *lastAuthCodeDate;
@property (nonatomic, retain) NSTimer *countDownTimer;


- (void)allowFriendContact:(UIButton *)sender;
- (IBAction)regist:(UIButton *)sender;
- (IBAction)getAuthCode:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIImageView *friendContactImage;


@end
