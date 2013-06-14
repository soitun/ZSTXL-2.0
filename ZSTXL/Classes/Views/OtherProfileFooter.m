//
//  OtherProfileFooter.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-14.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "OtherProfileFooter.h"

@implementation OtherProfileFooter

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
    [self.addFriendButton addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addBlackButton addTarget:self action:@selector(addBlackAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addFriendAction
{
    PERFORM_SELECTOR(self.delegate, @selector(otherProfileAddFriend));
}

- (void)addBlackAction
{
    PERFORM_SELECTOR(self.delegate, @selector(otherProfileAddBlack));
}

- (void)dealloc {
    [_addFriendButton release];
    [_addBlackButton release];
    [super dealloc];
}
@end
