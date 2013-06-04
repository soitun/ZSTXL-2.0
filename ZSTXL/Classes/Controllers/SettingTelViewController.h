//
//  SettingTelViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-28.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTelViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *telTextField;
@property (retain, nonatomic) IBOutlet UIButton *authCodeButton;
@property (retain, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (retain, nonatomic) IBOutlet UIButton *saveButton;
@property (retain, nonatomic) IBOutlet UILabel *countDownLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) NSTimer *countDownTimer;
@property (retain, nonatomic) NSDate *lastAuthCodeDate;

@property (copy, nonatomic) NSString *tel;
@property (copy, nonatomic) NSString *authCode;


@end
