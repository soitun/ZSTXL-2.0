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

- (void)drawRect:(CGRect)rect
{
    [Utility addRoundCornerToView:self.avatar radius:5 borderColor:[UIColor clearColor]];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.starButton addTarget:self action:@selector(tapStar) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    [_avatar release];
    [_nameLabel release];
    [_useridLabel release];
    [_xunImage release];
    [_xunVImage release];
    [_xunBImage release];
    [_bgImage release];
    [_starButton release];
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
