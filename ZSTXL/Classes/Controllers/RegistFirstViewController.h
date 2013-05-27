//
//  RegistFirstViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistFirstViewController : UIViewController

@property (nonatomic, copy) NSString *tel;

@property (retain, nonatomic) IBOutlet UILabel *telLabel;

@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwdTextField;
@property (retain, nonatomic) IBOutlet UITextField *inviteTextField;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)confirm:(UIButton *)sender;

@end
