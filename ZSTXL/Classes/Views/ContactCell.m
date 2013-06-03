//
//  ContactCell.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar)] autorelease];
    [self.headIcon addGestureRecognizer:tap];
}

- (void)dealloc {
    [_headIcon release];
    [_nameLabel release];
    [_xun_VImage release];
    [_ZDLabel release];
    [super dealloc];
}

#pragma mark - tap avatar

- (void)tapAvatar
{
    if ([self.delegate respondsToSelector:@selector(contactCellTapAvatarOfContact:)]) {
        [self.delegate performSelector:@selector(contactCellTapAvatarOfContact:) withObject:self.contact];
    }
}

@end
