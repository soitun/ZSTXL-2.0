//
//  MailNextPreView.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MailNextPreViewDelegate <NSObject>

- (void)mailNext;
- (void)mailPre;

@end

@interface MailNextPreView : UIView

- (IBAction)mailPreAction:(UIButton *)sender;
- (IBAction)mailNextAction:(UIButton *)sender;
@property (nonatomic, assign) id<MailNextPreViewDelegate> delegate;

@end
