//
//  TimePicker.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-29.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "TimePicker.h"

@implementation TimePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    va_list args;
    va_start(args, otherButtonTitles);
    self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, args, nil];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy MM dd"];
        
        NSTimeZone *tz = [NSTimeZone systemTimeZone];
        [dateFormatter setTimeZone:tz];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.timeZone = [NSTimeZone localTimeZone];
        NSDate *maxDate = [NSDate date];
        NSDate *minDate = [dateFormatter dateFromString:@"1950 01 01"];
        
        
        
        [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        self.datePicker.maximumDate = maxDate;
        self.datePicker.minimumDate = minDate;
        
        self.topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.topBar.barStyle=UIBarStyleBlackTranslucent;
        [self.topBar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(datePickerDoneClick)];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:self
                                                                                   action:nil];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                      target:self
                                                                                      action:@selector(datePickerCancelClick)];
        [barItems addObject:cancelButton];
        [barItems addObject:flexSpace];
        [barItems addObject:doneButton];
        
        [self.topBar setItems:barItems animated:YES];
        [self addSubview:self.topBar];
        [self addSubview:self.datePicker];
        self.datePicker.frame = CGRectMake(0, SCREEN_HEIGHT-64-44-self.datePicker.frame.size.height, 320, self.datePicker.frame.size.height+44);
    }
    
    va_end(args);
    return self;
}

- (void)datePickerDoneClick
{
    
}

- (void)datePickerCancelClick
{
    
}

@end
