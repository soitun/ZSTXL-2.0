//
//  ModifyPasswdViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-5.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswdViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *oldPasswdTextField;
@property (retain, nonatomic) IBOutlet UITextField *theNewPasswdTextField;
@property (retain, nonatomic) IBOutlet UITextField *renewPasswdTextField;


@property (copy, nonatomic) NSString *oldPasswd;
@property (copy, nonatomic) NSString *theNewPasswd;
@property (copy, nonatomic) NSString *renewPasswd;

- (IBAction)saveAction:(UIButton *)sender;

@end
