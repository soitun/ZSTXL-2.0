//
//  TimePicker.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-29.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "TimePicker.h"

@implementation TimePicker


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.titleToolbar.barStyle = UIBarStyleBlackTranslucent;
}

- (id)initWithTitle:(NSString *)title delegate:(id<TimePickerDelegate>)timePickerDelegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TimePicker" owner:nil options:nil] lastObject];
    if (self) {
        self.titleToolbar.translucent = YES;
        self.titleToolbar.barStyle = UIBarStyleBlackTranslucent;
        self.timePickerDelegate = timePickerDelegate;
        self.titleLab.text = title;
    }
    return self;
}

#define kDuration 0.3

- (void)showInView:(UIView *)view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}

- (void)dealloc
{
    [_titleLab release];
    [_titleToolbar release];
    [super dealloc];
}

- (IBAction)cancelCilck:(UIBarButtonItem *)sender
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
}

- (IBAction)doneClick:(UIBarButtonItem *)sender
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if ([self.timePickerDelegate respondsToSelector:@selector(timePickerConfirm:)]) {
        [self.timePickerDelegate performSelector:@selector(timePickerConfirm:) withObject:self];
    }
}
@end
