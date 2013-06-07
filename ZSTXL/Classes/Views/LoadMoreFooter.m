//
//  LoadMoreFooter.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "LoadMoreFooter.h"

@implementation LoadMoreFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMe:)];
    [self addGestureRecognizer:tap];
}

- (void)dealloc {
    [_indicator release];
    [_titleLabel release];
    [super dealloc];
}

#pragma mark - tap

- (void)tapMe:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(LoadMoreFooterTap:)]) {
        [self.delegate performSelector:@selector(LoadMoreFooterTap:) withObject:self];
    }
}

@end
