//
//  TheNewMessageCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "TheNewMessageCell.h"

@implementation TheNewMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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
    [super drawRect:rect];
    [Utility addRoundCornerToView:self.avatar radius:3 borderColor:[UIColor clearColor]];
}

- (void)dealloc {
    [_avatar release];
    [_chatIcon release];
    [_mailIcon release];
    [_messageIcon release];
    [_nameLabel release];
    [_contentLabel release];
    [_dateLabel release];
    [super dealloc];
}
@end
