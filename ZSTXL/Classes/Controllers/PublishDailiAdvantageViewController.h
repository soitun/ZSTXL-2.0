//
//  PublishDailiAdvantageViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmFooterView.h"

@interface PublishDailiAdvantageViewController : UIViewController <ConfirmFooterViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIImageView *textFieldBg;
@property (nonatomic, retain) ConfirmFooterView *footer;

@end
