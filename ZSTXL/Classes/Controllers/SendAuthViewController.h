//
//  SendAuthViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-24.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendAuthViewController : UIViewController
- (IBAction)sendAuth:(UIButton *)sender;
- (IBAction)nextStep:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UILabel *telLabel;
@property (retain, nonatomic) IBOutlet UITextField *authcodeTextField;
@property (nonatomic, copy) NSString *tel;

@end
