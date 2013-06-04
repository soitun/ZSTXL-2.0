//
//  RegistFirstViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistFirstViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, copy) NSString *tel;

@property (retain, nonatomic) IBOutlet UILabel *telLabel;

@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwdTextField;
@property (retain, nonatomic) IBOutlet UITextField *inviteTextField;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger allowFriendContact; //0 允许 1 不允许

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *passwd;
@property (nonatomic, copy) NSString *inviteUserId;
@property (nonatomic, copy) NSString *userId;


- (IBAction)confirm:(UIButton *)sender;

@end
