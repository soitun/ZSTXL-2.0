//
//  MailNextPreView.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailNextPreView.h"

@implementation MailNextPreView

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

- (IBAction)mailPreAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(mailPre));
}

- (IBAction)mailNextAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(mailNext));
}

@end
