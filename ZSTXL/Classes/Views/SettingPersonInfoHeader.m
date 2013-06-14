//
//  SettingPersonInfoHeader.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-14.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingPersonInfoHeader.h"

@implementation SettingPersonInfoHeader

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

- (void)dealloc {
    [_avatar release];
    [_userIdLabel release];
    [_telLabel release];
    [super dealloc];
}
@end
