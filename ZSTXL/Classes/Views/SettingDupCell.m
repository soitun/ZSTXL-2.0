//
//  SettingDupCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-29.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "SettingDupCell.h"

@implementation SettingDupCell

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

- (void)dealloc {
    [_selectImage release];
    [_titleLabel release];
    [super dealloc];
}
@end
