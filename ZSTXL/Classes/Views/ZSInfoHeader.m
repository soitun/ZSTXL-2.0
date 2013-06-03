//
//  ZSInfoHeader.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ZSInfoHeader.h"

@implementation ZSInfoHeader

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar)];
    [self.starImage addGestureRecognizer:tap];
}

- (void)dealloc {
    [_avatar release];
    [_nameLabel release];
    [_useridLabel release];
    [_xunImage release];
    [_xunVImage release];
    [_xunBImage release];
    [_bgImage release];
    [_starImage release];
    [super dealloc];
}

- (IBAction)contactMe:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zsInfoHeaderContactMe)]) {
        [self.delegate performSelector:@selector(zsInfoHeaderContactMe)];
    }
}

- (void)tapStar
{
    if ([self.delegate respondsToSelector:@selector(zsINfoHeaderContactStar)]) {
        [self.delegate performSelector:@selector(zsINfoHeaderContactStar)];
    }
}

@end
