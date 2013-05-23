//
//  cityTitleView.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-23.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "CityTitleView.h"

@implementation CityTitleView

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
    [_cityLabel release];
    [super dealloc];
}
@end
