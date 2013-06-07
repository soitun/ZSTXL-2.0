//
//  PublishDailiAdvantageViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-2.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmFooterView.h"

@protocol PublishDailiAdvantageViewControllerDelegate  <NSObject>

- (void)publishDailiAdvantageFinish:(NSString *)string;

@end


@interface PublishDailiAdvantageViewController : UIViewController <ConfirmFooterViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIImageView *textFieldBg;
@property (nonatomic, retain) ConfirmFooterView *footer;
@property (nonatomic, copy) NSString *dailiAdvantage;

@property (nonatomic, assign) id<PublishDailiAdvantageViewControllerDelegate> delegate;

@end
