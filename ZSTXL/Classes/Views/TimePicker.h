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
- (IBAction)cancelCilck:(UIBarButtonItem *)sender;
- (IBAction)doneClick:(UIBarButtonItem *)sender;

@property (retain, nonatomic) IBOutlet UIToolbar *titleToolbar;
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) id<TimePickerDelegate> timePickerDelegate;

- (id)initWithTitle:(NSString *)title delegate:(id<TimePickerDelegate>)timePickerDelegate;


@end
