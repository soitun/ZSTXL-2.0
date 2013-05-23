//
//  LoadMoreCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-23.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell

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
    [_indicator release];
    [super dealloc];
}
@end
