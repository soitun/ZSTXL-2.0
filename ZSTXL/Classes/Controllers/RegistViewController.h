//
//  RegistViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *telTextField;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (nonatomic, assign) BOOL isAllowFriendContact;

- (void)allowFriendContact:(UIButton *)sender;
- (IBAction)regist:(UIButton *)sender;
- (IBAction)getAuthCode:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIButton *allowFriendContactButton;

@end
