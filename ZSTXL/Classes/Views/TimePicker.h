//
//  TimePicker.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-29.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimePicker;

@protocol TimePickerDelegate <NSObject>

- (void)timePickerCancel:(TimePicker *)picker;
- (void)timePickerConfirm:(TimePicker *)picker;

@end

@interface TimePicker : UIActionSheet

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIToolbar *topBar;
@property (nonatomic, assign) id<TimePickerDelegate> timePickerDelegate;

@end
