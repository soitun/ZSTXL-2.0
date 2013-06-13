//
//  OtherProfileContactCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "OtherProfileContactCell.h"

@implementation OtherProfileContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self.telButton addTarget:self action:@selector(telAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageButton addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mailButton addTarget:self action:@selector(mailAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatButton addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)drawRect:(CGRect)rect
{
    self.telButton.frame = CGRectMake(-1, -1, 72, 45);
    self.messageButton.frame = CGRectMake(71, -1, 71, 45.5);
    self.mailButton.frame = CGRectMake(142, -1, 71, 45.5);
    self.chatButton.frame = CGRectMake(213, -1, 72, 45);
}

- (void)setFrame:(CGRect)frame
{
    CGFloat inset = 8.f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)telAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(OtherProfileTel));
}

- (void)messageAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(OtherProfileMessage));
}

- (void)mailAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(OtherProfileMail));
}

- (void)chatAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(OtherProfileChat));
}

- (void)dealloc {
    [_telButton release];
    [_messageButton release];
    [_mailButton release];
    [_chatButton release];
    [super dealloc];
}
@end
