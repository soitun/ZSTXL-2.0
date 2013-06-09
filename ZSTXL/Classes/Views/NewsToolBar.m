//
//  NewsToolBar.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "NewsToolBar.h"

@implementation NewsToolBar

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
    [self.newsStarButton addTarget:self action:@selector(newsStarAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)newsStarAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(newsStar));
}

- (IBAction)newUpAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(newsUp));
}

- (IBAction)newDownAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(newsDown));
}

- (IBAction)newsContactAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(newsContact));
}
- (void)dealloc {
    [_newsStarButton release];
    [super dealloc];
}
@end
