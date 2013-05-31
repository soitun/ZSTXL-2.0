//
//  SuspensionButton.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SuspensionButton.h"

@implementation SuspensionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.frame = frame;
        [self setBackgroundImage:[UIImage imageNamed:@"sift"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"sift_p"] forState:UIControlStateHighlighted];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 3, 0);
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

@end
