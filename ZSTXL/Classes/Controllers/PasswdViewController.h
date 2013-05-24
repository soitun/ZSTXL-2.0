//
//  PasswdViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswdViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *passwdField;
@property (retain, nonatomic) IBOutlet UITextField *rePasswdField;
- (IBAction)confirm:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@end
