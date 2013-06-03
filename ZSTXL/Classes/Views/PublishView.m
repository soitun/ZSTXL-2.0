//
//  PublishView.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PublishView.h"

@implementation PublishView

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

- (IBAction)PublishZhaoshang:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(publishViewZhaoshang)]) {
        [self.delegate performSelector:@selector(publishViewZhaoshang)];
    }
}

- (IBAction)PublishDaili:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(publishViewDaili)]) {
        [self.delegate performSelector:@selector(publishViewDaili)];
    }
}

- (IBAction)PublishCancel:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(publishViewCancel)]) {
        [self.delegate performSelector:@selector(publishViewCancel)];
    }
}
@end
