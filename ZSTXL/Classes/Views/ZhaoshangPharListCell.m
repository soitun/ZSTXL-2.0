//
//  ZhaoshangPharListCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-14.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ZhaoshangPharListCell.h"

@implementation ZhaoshangPharListCell

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
    [_pharImage release];
    [_zsdlBaseImage release];
    [_pharNameLabel release];
    [_companyNameLabel release];
    [_areaLabel release];
    [_usernameLabel release];
    [_xunImage release];
    [_xunVImage release];
    [_xunBImage release];
    [_zsdlLabel release];
    [super dealloc];
}
@end
