//
//  PharCategoryCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PharCategoryCell.h"

@implementation PharCategoryCell

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
    [self.bottomButton addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    [_pharImage release];
    [_nameLabel release];
    [_detailLabel release];
    [_theNewImage release];
    [_bottomButton release];
    [super dealloc];
}

- (void)touchAction
{
    if ([self.delegate respondsToSelector:@selector(pharCategotyCellTap)]) {
        [self.delegate performSelector:@selector(pharCategotyCellTap)];
    }
}

@end
