//
//  SettingCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

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

- (void)awakeFromNib
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapselect:)];
    [self.selectImage addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapswitch:)];
    [self.switchImage  addGestureRecognizer:tap2];
}

- (void)setFrame:(CGRect)frame {
    CGFloat inset = 8.f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    
    [super setFrame:frame];
}

- (void)dealloc {
    [_selectImage release];
    [_switchImage release];
    [_onLabel release];
    [_offLabel release];
    [super dealloc];
}

#pragma mark - tap

- (void)tapselect:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(select:)]) {
        [self.delegate performSelector:@selector(select:) withObject:self];
    }
}

- (void)tapswitch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(switchOnOff:)]) {
        [self.delegate performSelector:@selector(switchOnOff:) withObject:self];
    }
}

@end
