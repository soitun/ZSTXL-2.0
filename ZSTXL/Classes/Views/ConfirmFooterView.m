//
//  ConfirmFooterView.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ConfirmFooterView.h"

@implementation ConfirmFooterView

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

- (void)dealloc {
    [super dealloc];
}
- (IBAction)leftAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(confirmFooterViewLeftAction)]) {
        [self.delegate performSelector:@selector(confirmFooterViewLeftAction)];
    }
}

- (IBAction)rightAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(confirmFooterViewRightAction)]) {
        [self.delegate performSelector:@selector(confirmFooterViewRightAction)];
    }
}


@end
