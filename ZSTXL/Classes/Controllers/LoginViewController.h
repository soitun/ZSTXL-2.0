//
//  LoginViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *userIdTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwdTextField;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)login:(UIButton *)sender;
- (IBAction)regist:(UIButton *)sender;
- (IBAction)forgetPasswd:(UIButton *)sender;

@end
