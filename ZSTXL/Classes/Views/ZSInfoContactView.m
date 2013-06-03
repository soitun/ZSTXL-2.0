//
//  ZSInfoContactView.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ZSInfoContactView.h"

@implementation ZSInfoContactView

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

- (IBAction)tel:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zsInfoContactViewTel)]) {
        [self.delegate performSelector:@selector(zsInfoContactViewTel)];
    }
}

- (IBAction)chat:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zsInfoContactViewChat)]) {
        [self.delegate performSelector:@selector(zsInfoContactViewChat)];
    }
}
@end
