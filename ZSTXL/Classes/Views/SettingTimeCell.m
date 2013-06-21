//
//  SettingTimeCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingTimeCell.h"

@implementation SettingTimeCell

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

- (void)setFrame:(CGRect)frame
{
    CGFloat inset = 8.f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    
    [super setFrame:frame];
}

- (void)dealloc {
    [_nameLabel release];
    [_detailLabel release];
    [super dealloc];
}
@end
