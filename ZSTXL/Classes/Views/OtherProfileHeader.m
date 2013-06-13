//
//  OtherProfileHeader.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "OtherProfileHeader.h"

@implementation OtherProfileHeader

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
    [Utility addRoundCornerToView:self.avatar radius:5];
}

- (void)dealloc {
    [_avatar release];
    [_nameLabel release];
    [_userIdLabel release];
    [_xunImage release];
    [_xunVImage release];
    [_xunBImage release];
    [super dealloc];
}

- (IBAction)commentAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(otherProfileHeaderComment));
}

@end
