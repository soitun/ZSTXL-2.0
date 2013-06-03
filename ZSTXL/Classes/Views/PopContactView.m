//
//  ContactView.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PopContactView.h"

@implementation PopContactView

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
    [_avatar release];
    [_nameLabel release];
    [_useridLabel release];
    [_xunImage release];
    [_xunVImage release];
    [_xunBImage release];
    [super dealloc];
}
- (IBAction)telAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(popContactViewTel)]) {
        [self.delegate performSelector:@selector(popContactViewTel)];
    }
    
}

- (IBAction)chatAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(popContactViewChat)]) {
        [self.delegate performSelector:@selector(popContactViewChat)];
    }
}

@end
