//
//  MyProfileContactCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MyProfileContactCell.h"

@implementation MyProfileContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    //test
    self.messageButton.frame = CGRectMake(-1, -1, 95, 50);
    self.mailButton.frame = CGRectMake(94, -1, 96, 50);
    self.chatButton.frame = CGRectMake(190, -1, 95, 50);
    
    self.messageBadge = [CustomBadge customBadgeWithString:self.messageBadgeValue];
    self.messageBadge.frame = CGRectMake(95-6, -12, 25, 25);
    [self addSubview:self.messageBadge];
    self.messageBadge.hidden = YES;
    
    if ([self.messageBadgeValue isValid] && ![self.messageBadgeValue isEqualToString:@"0"]) {
        self.messageBadge.hidden = NO;
    }
    else{
        self.messageBadge.hidden = YES;
    }
    
    self.mailBadge = [CustomBadge customBadgeWithString:self.mailBadgeValue];
    self.mailBadge.frame = CGRectMake(94+96-6, -12, 25, 25);
    [self addSubview:self.mailBadge];

    if ([self.mailBadgeValue isValid] && ![self.mailBadgeValue isEqualToString:@"0"]) {
        self.mailBadge.hidden = NO;
    }
    else{
        self.mailBadge.hidden = YES;
    }
    
    self.chatBadge = [CustomBadge customBadgeWithString:self.chatBadgeValue];
    self.chatBadge.frame = CGRectMake(190+95-6, -12, 25, 25);
    [self addSubview:self.chatBadge];
    self.chatBadge.hidden = YES;
    if ([self.chatBadgeValue isValid] && ![self.chatBadgeValue isEqualToString:@"0"]) {
        self.mailBadge.hidden = NO;
    }
    else{
        self.mailBadge.hidden = YES;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.messageButton addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mailButton addTarget:self action:@selector(mailAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatButton addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setFrame:(CGRect)frame
{
    CGFloat inset = 8.f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}

- (void)messageAction:(UIButton *)sender
{
    if (self.messageBadge) {
        [self.messageBadge removeFromSuperview];
        self.messageBadge = nil;
    }
    PERFORM_SELECTOR(self.delegate, @selector(myProfileMessage));
}

- (void)mailAction:(UIButton *)sender
{
    if (self.mailBadge) {
        [self.mailBadge removeFromSuperview];
        self.mailBadge = nil;
    }
    PERFORM_SELECTOR(self.delegate, @selector(myProfileMail));
}

- (void)chatAction:(UIButton *)sender
{
    if (self.chatBadge) {
        [self.chatBadge removeFromSuperview];
        self.chatBadge = nil;
    }
    PERFORM_SELECTOR(self.delegate, @selector(myProfileChat));
}

- (void)dealloc
{
    [_messageButton release];
    [_mailButton release];
    [_chatButton release];
    [super dealloc];
}
@end
