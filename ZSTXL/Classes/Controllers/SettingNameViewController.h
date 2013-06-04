//
//  SettingNameViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-28.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingNameViewController : UIViewController <UITextFieldDelegate>

- (IBAction)saveName:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;

@property (copy, nonatomic) NSString *name;

@end
